<?php

namespace App\Filament\Resources\JobPosts\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Actions\ForceDeleteBulkAction;
use Filament\Actions\RestoreBulkAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\TrashedFilter;
use Filament\Tables\Table;

class JobPostsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('title')
                    ->label('Judul Lowongan')
                    ->searchable()
                    ->sortable()
                    ->weight('bold')
                    ->limit(35),

                TextColumn::make('employer.company_name')
                    ->label('Perusahaan BUJP')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('location.name')
                    ->label('Lokasi Penempatan')
                    ->badge()
                    ->color('gray')
                    ->searchable(),

                TextColumn::make('required_certificate_level')
                    ->label('Kualifikasi Gada')
                    ->badge()
                    ->colors([
                        'info' => 'gada_pratama',
                        'warning' => 'gada_madya',
                        'danger' => 'gada_utama',
                        'gray' => 'none',
                    ])
                    ->formatStateUsing(fn(string $state) => strtoupper(str_replace('_', ' ', $state))),

                TextColumn::make('salary_min')
                    ->label('Rentang Gaji')
                    ->formatStateUsing(function ($record) {
                        if ($record->salary_is_hidden || (!$record->salary_min && !$record->salary_max)) {
                            return 'Negosiasi';
                        }
                        return 'Rp ' . number_format($record->salary_min, 0, ',', '.') . ' - Rp ' . number_format($record->salary_max, 0, ',', '.');
                    }),

                TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->colors([
                        'success' => 'published',
                        'warning' => 'review',
                        'gray' => 'draft',
                        'danger' => 'rejected',
                        'info' => 'closed',
                    ]),

                IconColumn::make('is_urgent')
                    ->label('Urgent')
                    ->boolean(),

                IconColumn::make('is_featured')
                    ->label('Featured')
                    ->boolean(),

                TextColumn::make('published_at')
                    ->label('Tgl Tayang')
                    ->date('d M Y')
                    ->sortable(),
            ])
            ->filters([
                SelectFilter::make('status')
                    ->options([
                        'published' => 'Published',
                        'review' => 'Under Review',
                        'draft' => 'Draft',
                        'closed' => 'Closed',
                        'rejected' => 'Rejected',
                    ]),
                TrashedFilter::make(),
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                    ForceDeleteBulkAction::make(),
                    RestoreBulkAction::make(),
                ]),
            ]);
    }
}
