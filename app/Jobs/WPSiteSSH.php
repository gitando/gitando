<?php

namespace App\Jobs;

use phpseclib3\Net\SSH2;
use Illuminate\Bus\Queueable;
use Illuminate\Queue\SerializesModels;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Contracts\Queue\ShouldBeUnique;

class SslSiteSSH implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $site;
    protected $wp;

    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct($site, $wp)
    {
        $this->site = $site;
        $this->wp = $wp;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        $ssh = new SSH2($this->site->server->ip, 22);
        $ssh->login('gitando', $this->site->server->password);
        $ssh->setTimeout(360);

        $ssh->exec('echo '.$this->server->password.' | sudo -S sudo unlink wpinstall');
        $ssh->exec('echo '.$this->server->password.' | sudo -S sudo wget '.config('app.url').'/sh/wpinstall');
        $ssh->exec('echo '.$this->server->password.' | sudo -S sudo dos2unix wpinstall');
        $ssh->exec('echo '.$this->server->password.' | sudo -S sudo bash wpinstall -u '.$this->site->username.' -p '.$this->site->database.' -l '.$this->site->domain.' -wpu '.$this->wp['user'].' -wpp '.$this->wp['pass'].' -wpm '.$this->wp['mail'].' -b '.$this->site->basepath);
        $ssh->exec('echo '.$this->server->password.' | sudo -S sudo unlink wpinstall');

        $ssh->exec('exit');
    }
}
