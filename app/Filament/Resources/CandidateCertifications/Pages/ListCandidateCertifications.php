<?php

namespace App\Filament\Resources\CandidateCertifications\Pages;

use App\Filament\Resources\CandidateCertifications\CandidateCertificationResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListCandidateCertifications extends ListRecords
{
    protected static string $resource = CandidateCertificationResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
