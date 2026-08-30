<?php

namespace App\Filament\Resources\HomepageSections\Schemas;

use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class HomepageSectionForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('section_key')
                    ->required(),
                TextInput::make('title')
                    ->required(),
                TextInput::make('subtitle'),
                Toggle::make('is_visible')
                    ->required(),
                TextInput::make('sort_order')
                    ->required()
                    ->numeric()
                    ->default(0),
                TextInput::make('config'),
            ]);
    }
}
