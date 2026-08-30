<?php

namespace App\Filament\Resources\CandidateDocuments\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class CandidateDocumentsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('candidate.user.name')
                    ->label('Nama Kandidat')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('type')
                    ->label('Jenis Dokumen')
                    ->badge()
                    ->color('primary')
                    ->formatStateUsing(fn(string $state) => strtoupper($state)),

                TextColumn::make('title')
                    ->label('Judul Berkas')
                    ->searchable(),

                TextColumn::make('file_size')
                    ->label('Ukuran')
                    ->formatStateUsing(fn($state) => $state ? round($state / 1024) . ' KB' : '-'),

                TextColumn::make('verification_status')
                    ->label('Status')
                    ->badge()
                    ->colors([
                        'warning' => 'pending',
                        'success' => 'verified',
                        'danger' => 'rejected',
                    ]),

                TextColumn::make('created_at')
                    ->label('Tgl Unggah')
                    ->dateTime('d M Y H:i')
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
