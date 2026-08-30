<?php

namespace App\Filament\Resources\CareerArticles\Pages;

use App\Filament\Resources\CareerArticles\CareerArticleResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditCareerArticle extends EditRecord
{
    protected static string $resource = CareerArticleResource::class;

    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
