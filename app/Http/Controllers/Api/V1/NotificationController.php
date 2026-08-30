<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\DeviceToken;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class NotificationController extends Controller
{
    /**
     * List user's in-app notifications.
     */
    public function index(Request $request): JsonResponse
    {
        $user = $request->user();
        $unreadCount = $user->unreadNotifications()->count();

        $notifications = $user->notifications()
            ->paginate($request->integer('per_page', 20));

        return response()->json([
            'success' => true,
            'data' => [
                'unread_count' => $unreadCount,
                'items' => $notifications->map(function ($notif) {
                    return [
                        'id' => $notif->id,
                        'type' => $notif->data['type'] ?? 'general',
                        'title' => $notif->data['title'] ?? 'Pemberitahuan Satpamku',
                        'message' => $notif->data['message'] ?? '',
                        'payload' => $notif->data,
                        'read_at' => $notif->read_at?->toIso8601String(),
                        'created_at' => $notif->created_at->toIso8601String(),
                    ];
                }),
            ],
            'meta' => [
                'current_page' => $notifications->currentPage(),
                'last_page' => $notifications->lastPage(),
                'per_page' => $notifications->perPage(),
                'total' => $notifications->total(),
            ],
        ]);
    }

    /**
     * Mark a specific notification as read.
     */
    public function markAsRead(Request $request, string $id): JsonResponse
    {
        $notification = $request->user()->notifications()->where('id', $id)->first();

        if (!$notification) {
            return response()->json(['success' => false, 'message' => 'Notifikasi tidak ditemukan.'], 404);
        }

        $notification->markAsRead();

        return response()->json([
            'success' => true,
            'message' => 'Notifikasi ditandai telah dibaca.',
            'data' => [
                'id' => $notification->id,
                'read_at' => $notification->read_at?->toIso8601String(),
            ],
        ]);
    }

    /**
     * Mark all notifications as read.
     */
    public function markAllAsRead(Request $request): JsonResponse
    {
        $request->user()->unreadNotifications->markAsRead();

        return response()->json([
            'success' => true,
            'message' => 'Semua notifikasi berhasil ditandai telah dibaca.',
        ]);
    }

    /**
     * Register or update FCM device token.
     */
    public function storeDeviceToken(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'fcm_token' => ['required', 'string'],
            'device_type' => ['nullable', 'string', 'in:android,ios,web'],
        ]);

        $token = DeviceToken::updateOrCreate(
            [
                'user_id' => $request->user()->id,
                'fcm_token' => $validated['fcm_token'],
            ],
            [
                'device_type' => $validated['device_type'] ?? 'android',
                'last_used_at' => now(),
            ]
        );

        return response()->json([
            'success' => true,
            'message' => 'Device token berhasil disimpan.',
            'data' => [
                'id' => $token->id,
                'device_type' => $token->device_type,
            ],
        ]);
    }

    /**
     * Unregister device token upon logout.
     */
    public function destroyDeviceToken(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'fcm_token' => ['required', 'string'],
        ]);

        DeviceToken::where('user_id', $request->user()->id)
            ->where('fcm_token', $validated['fcm_token'])
            ->delete();

        return response()->json([
            'success' => true,
            'message' => 'Device token berhasil dihapus.',
        ]);
    }
}
