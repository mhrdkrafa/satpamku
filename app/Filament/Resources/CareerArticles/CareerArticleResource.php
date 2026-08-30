<?php

namespace App\Filament\Resources\CareerArticles;

use App\Filament\Resources\CareerArticles\Pages\CreateCareerArticle;
use App\Filament\Resources\CareerArticles\Pages\EditCareerArticle;
use App\Filament\Resources\CareerArticles\Pages\ListCareerArticles;
use App\Filament\Resources\CareerArticles\Schemas\CareerArticleForm;
use App\Filament\Resources\CareerArticles\Tables\CareerArticlesTable;
use App\Models\CareerArticle;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class CareerArticleResource extends Resource
{
    protected static ?string $model = CareerArticle::class;

    protected static \UnitEnum|string|null $navigationGroup = 'CMS & Konten Web';
    protected static ?string $modelLabel = 'Artikel Panduan Karir';
    protected static ?string $pluralModelLabel = 'Pusat Edukasi & Artikel';

    public static function form(Schema $schema): Schema
    {
        return CareerArticleForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return CareerArticlesTable::configure($table);
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
            'index' => ListCareerArticles::route('/'),
            'create' => CreateCareerArticle::route('/create'),
            'edit' => EditCareerArticle::route('/{record}/edit'),
        ];
    }
}
