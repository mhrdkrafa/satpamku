<?php

namespace App\Filament\Resources\CandidateDocuments;

use App\Filament\Resources\CandidateDocuments\Pages\CreateCandidateDocument;
use App\Filament\Resources\CandidateDocuments\Pages\EditCandidateDocument;
use App\Filament\Resources\CandidateDocuments\Pages\ListCandidateDocuments;
use App\Filament\Resources\CandidateDocuments\Schemas\CandidateDocumentForm;
use App\Filament\Resources\CandidateDocuments\Tables\CandidateDocumentsTable;
use App\Models\CandidateDocument;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class CandidateDocumentResource extends Resource
{
    protected static ?string $model = CandidateDocument::class;

    protected static string|BackedEnum|null $navigationIcon = Heroicon::OutlinedRectangleStack;

    protected static \UnitEnum|string|null $navigationGroup = 'Verifikasi Kandidat';

    public static function form(Schema $schema): Schema
    {
        return CandidateDocumentForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return CandidateDocumentsTable::configure($table);
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
            'index' => ListCandidateDocuments::route('/'),
            'create' => CreateCandidateDocument::route('/create'),
            'edit' => EditCandidateDocument::route('/{record}/edit'),
        ];
    }
}
