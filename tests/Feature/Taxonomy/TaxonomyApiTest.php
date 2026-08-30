<?php

use Database\Seeders\TaxonomySeeder;

beforeEach(function () {
    $this->seed(TaxonomySeeder::class);
});

test('can retrieve locations list and tree structure', function () {
    $response = $this->getJson('/api/v1/taxonomy/locations');

    $response->assertOk()
        ->assertJson(['success' => true])
        ->assertJsonStructure([
            'success',
            'data' => [
                '*' => ['id', 'name', 'slug', 'type', 'is_active'],
            ],
        ]);

    // Test tree filter
    $treeResponse = $this->getJson('/api/v1/taxonomy/locations?tree=1');
    $treeResponse->assertOk()
        ->assertJsonStructure([
            'data' => [
                '*' => [
                    'id', 'name', 'type', 'children' => [
                        '*' => ['id', 'name', 'type'],
                    ],
                ],
            ],
        ]);
});

test('can retrieve job categories with positions', function () {
    $response = $this->getJson('/api/v1/taxonomy/categories');

    $response->assertOk()
        ->assertJson(['success' => true])
        ->assertJsonStructure([
            'data' => [
                '*' => [
                    'id', 'name', 'slug', 'description', 'icon', 'sort_order', 'positions' => [
                        '*' => ['id', 'name', 'slug'],
                    ],
                ],
            ],
        ]);

    expect(collect($response->json('data'))->pluck('name'))->toContain('Retail', 'VIP', 'Residensial', 'Event', 'Industri');
});

test('can filter positions by category slug', function () {
    $response = $this->getJson('/api/v1/taxonomy/positions?category_slug=retail');

    $response->assertOk()
        ->assertJson(['success' => true]);

    $positions = collect($response->json('data'))->pluck('name');
    expect($positions)->toContain('Danru Retail (Mall)');
});

test('can retrieve facilities and benefits', function () {
    $response = $this->getJson('/api/v1/taxonomy/facilities');

    $response->assertOk()
        ->assertJson(['success' => true]);

    $facilities = collect($response->json('data'))->pluck('name');
    expect($facilities)->toContain('BPJS Kesehatan', 'BPJS Ketenagakerjaan', 'Seragam Lengkap Disediakan');
});

test('can retrieve skills and certifications', function () {
    $skillsResponse = $this->getJson('/api/v1/taxonomy/skills');
    $skillsResponse->assertOk()
        ->assertJson(['success' => true]);

    $certsResponse = $this->getJson('/api/v1/taxonomy/certifications');
    $certsResponse->assertOk()
        ->assertJson(['success' => true]);

    $certNames = collect($certsResponse->json('data'))->pluck('name');
    expect($certNames)->toContain('Gada Pratama', 'Gada Madya', 'Gada Utama', 'Ahli K3 Umum');
});

test('can retrieve all taxonomy bundle', function () {
    $response = $this->getJson('/api/v1/taxonomy/all');

    $response->assertOk()
        ->assertJson(['success' => true])
        ->assertJsonStructure([
            'data' => [
                'locations',
                'categories',
                'facilities',
                'skills',
                'certifications',
            ],
        ]);
});
