<?php

namespace App\Filament\Resources\Certifications\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\IconColumn;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class CertificationsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('name')
                    ->label('Nama Sertifikasi / Diklat')
                    ->searchable()
                    ->sortable()
                    ->weight('bold'),

                TextColumn::make('level')
                    ->label('Tingkatan (Level)')
                    ->badge()
                    ->color('primary')
                    ->formatStateUsing(fn(string $state) => strtoupper(str_replace('_', ' ', $state))),

                TextColumn::make('issuing_authority')
                    ->label('Lembaga Penerbit / Polda')
                    ->searchable(),

                IconColumn::make('is_active')
                    ->label('Status Aktif')
                    ->boolean(),

                TextColumn::make('sort_order')
                    ->label('Urutan')
                    ->sortable(),
            ])
            ->filters([
                //
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}
