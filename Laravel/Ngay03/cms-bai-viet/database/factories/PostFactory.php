<?php

namespace Database\Factories;

use Illuminate\Database\Eloquent\Factories\Factory;
use Illuminate\Support\Str;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\Post>
 */
class PostFactory extends Factory
{
    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $title = $this->faker->sentence(6, true);
        return [
        'title' => ucwords($title),
        'slug' => Str::slug($title),
        'content' => $this->faker->paragraphs(5, true),
        'status' => $this->faker->randomElement(['draft', 'published', 'archived']),
        'published_at' => $this->faker->optional()->dateTimeBetween('-1 month'),
    ];
    }
}
