<?php

namespace App\Filament\Resources\CandidateCertifications\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class CandidateCertificationsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('candidate.user.name')
                    ->label('Nama Personil Satpam')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('certification.name')
                    ->label('Sertifikat / Diklat')
                    ->badge()
                    ->color('info')
                    ->searchable(),

                TextColumn::make('certificate_number')
                    ->label('No. Registrasi / KTA')
                    ->searchable()
                    ->default('-'),

                TextColumn::make('issued_at')
                    ->label('Tgl Terbit')
                    ->date('d M Y')
                    ->sortable(),

                TextColumn::make('expires_at')
                    ->label('Masa Berlaku')
                    ->date('d M Y')
                    ->sortable(),

                TextColumn::make('verification_status')
                    ->label('Status')
                    ->badge()
                    ->colors([
                        'warning' => 'pending',
                        'success' => 'verified',
                        'danger' => 'rejected',
                        'gray' => 'expired',
                    ]),
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
