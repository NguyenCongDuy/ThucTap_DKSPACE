<?php

namespace Tests\Feature;

use Tests\TestCase;

/**
 * Kiểm tra response từ TranslatorInterface theo APP_LOCALE
 */
class GreetingTest extends TestCase
{
    public function test_vi_greeting()
    {
        config(['app.locale' => 'vi']);

        $response = $this->get('/greeting');
        $response->assertJson(['message' => 'Xin chào, quản trị viên']);
    }

    public function test_en_greeting()
    {
        config(['app.locale' => 'en']);

        $response = $this->get('/greeting');
        $response->assertJson(['message' => 'Hello, Admin']);
    }
}
