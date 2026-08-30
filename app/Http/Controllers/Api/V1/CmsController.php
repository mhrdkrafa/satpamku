<?php

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\Controller;
use App\Models\Banner;
use App\Models\CareerArticle;
use App\Models\Faq;
use App\Models\HomepageSection;
use App\Models\SiteSetting;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CmsController extends Controller
{
    /**
     * Public site settings & branding.
     */
    public function settings(): JsonResponse
    {
        $settings = SiteSetting::where('is_public', true)->get();

        $formatted = [];
        foreach ($settings as $setting) {
            $formatted[$setting->key] = SiteSetting::getVal($setting->key);
        }

        return response()->json([
            'success' => true,
            'data' => $formatted,
        ]);
    }

    /**
     * Active banners & promo slides.
     */
    public function banners(Request $request): JsonResponse
    {
        $query = Banner::active();

        if ($request->has('placement')) {
            $query->where('placement', $request->query('placement'));
        }

        $banners = $query->get();

        return response()->json([
            'success' => true,
            'data' => $banners->map(function ($b) {
                return [
                    'id' => $b->id,
                    'title' => $b->title,
                    'subtitle' => $b->subtitle,
                    'image_url' => $b->image_url,
                    'target_url' => $b->target_url,
                    'placement' => $b->placement,
                    'sort_order' => $b->sort_order,
                ];
            }),
        ]);
    }

    /**
     * Dynamic homepage sections composition & ordering.
     */
    public function homepage(): JsonResponse
    {
        $sections = HomepageSection::visible()->get();
        $banners = Banner::active()->where('placement', 'home_hero')->get();

        return response()->json([
            'success' => true,
            'data' => [
                'hero_banners' => $banners,
                'sections' => $sections->map(function ($sec) {
                    return [
                        'section_key' => $sec->section_key,
                        'title' => $sec->title,
                        'subtitle' => $sec->subtitle,
                        'sort_order' => $sec->sort_order,
                        'config' => $sec->config,
                    ];
                }),
            ],
        ]);
    }

    /**
     * Career resources & education articles list.
     */
    public function articles(Request $request): JsonResponse
    {
        $query = CareerArticle::published();

        if ($request->has('category') && $request->query('category') !== 'all') {
            $query->where('category', $request->query('category'));
        }

        $articles = $query->paginate($request->integer('per_page', 10));

        return response()->json([
            'success' => true,
            'data' => $articles->map(function ($art) {
                return [
                    'id' => $art->id,
                    'title' => $art->title,
                    'slug' => $art->slug,
                    'excerpt' => $art->excerpt,
                    'cover_image' => $art->cover_image,
                    'author_name' => $art->author_name,
                    'category' => $art->category,
                    'published_at' => $art->published_at?->toIso8601String(),
                    'view_count' => $art->view_count,
                ];
            }),
            'meta' => [
                'current_page' => $articles->currentPage(),
                'last_page' => $articles->lastPage(),
                'per_page' => $articles->perPage(),
                'total' => $articles->total(),
            ],
        ]);
    }

    /**
     * Single career article detail with view counter increment.
     */
    public function articleDetail(string $slug): JsonResponse
    {
        $article = CareerArticle::where('slug', $slug)->where('is_published', true)->first();

        if (!$article) {
            return response()->json(['success' => false, 'message' => 'Artikel tidak ditemukan.'], 404);
        }

        $article->increment('view_count');

        return response()->json([
            'success' => true,
            'data' => [
                'id' => $article->id,
                'title' => $article->title,
                'slug' => $article->slug,
                'excerpt' => $article->excerpt,
                'content' => $article->content,
                'cover_image' => $article->cover_image,
                'author_name' => $article->author_name,
                'category' => $article->category,
                'published_at' => $article->published_at?->toIso8601String(),
                'view_count' => $article->view_count,
            ],
        ]);
    }

    /**
     * Categorized FAQs.
     */
    public function faqs(Request $request): JsonResponse
    {
        $query = Faq::active();

        if ($request->has('category')) {
            $query->where('category', $request->query('category'));
        }

        $faqs = $query->get();

        return response()->json([
            'success' => true,
            'data' => $faqs->groupBy('category')->map(function ($items, $category) {
                return [
                    'category' => $category,
                    'items' => $items->map(function ($f) {
                        return [
                            'id' => $f->id,
                            'question' => $f->question,
                            'answer' => $f->answer,
                            'sort_order' => $f->sort_order,
                        ];
                    }),
                ];
            })->values(),
        ]);
    }
}
