<?php

namespace App\Filament\Resources\CandidateCertifications\Pages;

use App\Filament\Resources\CandidateCertifications\CandidateCertificationResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditCandidateCertification extends EditRecord
{
    protected static string $resource = CandidateCertificationResource::class;

    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
