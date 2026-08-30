<?php

namespace App\Filament\Resources\CareerArticles\Pages;

use App\Filament\Resources\CareerArticles\CareerArticleResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListCareerArticles extends ListRecords
{
    protected static string $resource = CareerArticleResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
