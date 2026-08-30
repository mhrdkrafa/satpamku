<?php

namespace App\Filament\Resources\CandidateDocuments\Pages;

use App\Filament\Resources\CandidateDocuments\CandidateDocumentResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditCandidateDocument extends EditRecord
{
    protected static string $resource = CandidateDocumentResource::class;

    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
