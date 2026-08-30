<?php

namespace App\Filament\Resources\CandidateDocuments\Pages;

use App\Filament\Resources\CandidateDocuments\CandidateDocumentResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListCandidateDocuments extends ListRecords
{
    protected static string $resource = CandidateDocumentResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
