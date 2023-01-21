<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\WithoutMiddleware;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class GitandoTest extends TestCase
{

    public function testShowLoginPage()
    {
        $response = $this->get('/login');
        $response->assertSee('Gitando');
        $response->assertStatus(200);
    }

}
