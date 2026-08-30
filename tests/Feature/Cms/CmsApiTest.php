<?php

use Database\Seeders\CmsSeeder;
use Database\Seeders\TaxonomySeeder;

beforeEach(function () {
    $this->seed(TaxonomySeeder::class);
    $this->seed(CmsSeeder::class);
});

test('public can retrieve site settings', function () {
    $response = $this->getJson('/api/v1/cms/settings');

    $response->assertOk()
        ->assertJsonPath('data.site_name', 'Satpamku')
        ->assertJsonPath('data.support_email', 'bantuan@satpamku.id');
});

test('public can retrieve active banners', function () {
    $response = $this->getJson('/api/v1/cms/banners');

    $response->assertOk()
        ->assertJsonCount(2, 'data')
        ->assertJsonPath('data.0.placement', 'home_hero');
});

test('public can retrieve homepage dynamic sections layout', function () {
    $response = $this->getJson('/api/v1/cms/homepage');

    $response->assertOk()
        ->assertJsonCount(2, 'data.hero_banners')
        ->assertJsonCount(6, 'data.sections')
        ->assertJsonPath('data.sections.0.section_key', 'hero_banner');
});

test('public can list career articles and view article detail with counter increment', function () {
    $listResponse = $this->getJson('/api/v1/cms/articles');

    $listResponse->assertOk()
        ->assertJsonCount(3, 'data');

    $slug = $listResponse->json('data.0.slug');

    $detailResponse = $this->getJson("/api/v1/cms/articles/{$slug}");

    $detailResponse->assertOk()
        ->assertJsonPath('data.slug', $slug)
        ->assertJsonPath('data.view_count', 1);

    // Hit again, counter increases
    $detailResponse2 = $this->getJson("/api/v1/cms/articles/{$slug}");
    $detailResponse2->assertOk()
        ->assertJsonPath('data.view_count', 2);
});

test('public can retrieve categorized faqs', function () {
    $response = $this->getJson('/api/v1/cms/faqs');

    $response->assertOk()
        ->assertJsonStructure([
            'success',
            'data' => [
                '*' => [
                    'category',
                    'items' => [
                        '*' => ['id', 'question', 'answer', 'sort_order'],
                    ],
                ],
            ],
        ]);
});
