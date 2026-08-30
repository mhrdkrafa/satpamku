<?php

namespace App\Filament\Resources\CandidateCertifications;

use App\Filament\Resources\CandidateCertifications\Pages\CreateCandidateCertification;
use App\Filament\Resources\CandidateCertifications\Pages\EditCandidateCertification;
use App\Filament\Resources\CandidateCertifications\Pages\ListCandidateCertifications;
use App\Filament\Resources\CandidateCertifications\Schemas\CandidateCertificationForm;
use App\Filament\Resources\CandidateCertifications\Tables\CandidateCertificationsTable;
use App\Models\CandidateCertification;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class CandidateCertificationResource extends Resource
{
    protected static ?string $model = CandidateCertification::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedRectangleStack;

    protected static \UnitEnum|string|null $navigationGroup = 'Verifikasi Kandidat';

    public static function form(Schema $schema): Schema
    {
        return CandidateCertificationForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return CandidateCertificationsTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListCandidateCertifications::route('/'),
            'create' => CreateCandidateCertification::route('/create'),
            'edit' => EditCandidateCertification::route('/{record}/edit'),
        ];
    }
}
