<?php

namespace App\Filament\Resources\Banners\Schemas;

use Filament\Forms\Components\DatePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class BannerForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('title')
                    ->required(),
                TextInput::make('subtitle'),
                FileUpload::make('image_url')
                    ->image()
                    ->required(),
                TextInput::make('target_url')
                    ->url(),
                TextInput::make('placement')
                    ->required()
                    ->default('home_hero'),
                Toggle::make('is_active')
                    ->required(),
                TextInput::make('sort_order')
                    ->required()
                    ->numeric()
                    ->default(0),
                DatePicker::make('start_date'),
                DatePicker::make('end_date'),
            ]);
    }
}
