<?php

namespace App\Console;

use Illuminate\Console\Scheduling\Schedule;
use Illuminate\Foundation\Console\Kernel as ConsoleKernel;

class Kernel extends ConsoleKernel
{
    /**
     * The Artisan commands provided by your application.
     *
     * @var array
     */
    protected $commands = [
        \App\Console\Commands\ActiveSetupCount::class,
        \App\Console\Commands\LogRotate::class,
        \App\Console\Commands\ServerSetupCheck::class,
        \App\Console\Commands\GitandoUpdate::class,
    ];

    /**
     * Define the application's command schedule.
     *
     * @param  \Illuminate\Console\Scheduling\Schedule  $schedule
     * @return void
     */
    protected function schedule(Schedule $schedule)
    {
        $tasklog = '/var/www/html/storage/task.log';

        $schedule->command('servers:setupcheck')->everyMinute()->sendOutputTo($tasklog);
        $schedule->command('gitando:update')->dailyAt('12:05')->sendOutputTo($tasklog);
        $schedule->command('gitando:logrotate')->dailyAt('00:00')->sendOutputTo($tasklog);
        $schedule->command('gitando:activesetupcount')->dailyAt('03:03')->sendOutputTo($tasklog);
    }

    /**
     * Register the commands for the application.
     *
     * @return void
     */
    protected function commands()
    {
        $this->load(__DIR__.'/Commands');
        require base_path('routes/console.php');
    }
}
