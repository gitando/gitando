<?php

namespace App\Console\Commands;

use App\Models\Server;
use phpseclib3\Net\SSH2;
use Illuminate\Console\Command;

class GitandoUpdate extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'gitando:update';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Update Gitando';

    /**
     * Create a new command instance.
     *
     * @return void
     */
    public function __construct()
    {
        parent::__construct();
    }

    /**
     * Execute the console command.
     *
     * @return int
     */
    public function handle()
    {
        $server = Server::where('default', 1)->first();

        print_r( $server );

        $ssh = new SSH2($server->ip, 22);
        $ssh->login('gitando', $server->password);
        $ssh->setTimeout(360);
        $ssh->exec('echo '.$server->password.' | sudo -s sh /var/www/html/utility/gitando-update/run.sh');
        $ssh->exec('exit');

        // 2023-01-17 patch
        $servers = Server::where('build', '<', '202311171')->get();

        foreach ($servers as $server) {
            $ssh = new SSH2($server->ip, 22);
            $ssh->login('gitando', $server->password);
            $ssh->setTimeout(360);
            $ssh->exec('echo '.$server->password.' | sudo -S sudo wget '.config('app.url').'/sh/client-patch/202311171');
            $ssh->exec('echo '.$server->password.' | sudo -S sudo dos2unix 202311171');
            $ssh->exec('echo '.$server->password.' | sudo -S sudo bash 202311171');
            $ssh->exec('echo '.$server->password.' | sudo -S sudo unlink 202311171');
            $ssh->exec('exit');

            $server->build = '202311171';
            $server->save();
        }

        // 2021-12-18 patch
        /* $servers = Server::where('build', '<', '202112181')->get();

        foreach ($servers as $server) {
            $ssh = new SSH2($server->ip, 22);
            $ssh->login('gitando', $server->password);
            $ssh->setTimeout(360);
            $ssh->exec('echo '.$server->password.' | sudo -S sudo wget '.config('app.url').'/sh/client-patch/202112181');
            $ssh->exec('echo '.$server->password.' | sudo -S sudo dos2unix 202112181');
            $ssh->exec('echo '.$server->password.' | sudo -S sudo bash 202112181');
            $ssh->exec('echo '.$server->password.' | sudo -S sudo unlink 202112181');
            $ssh->exec('exit');

            $server->build = '202112181';
            $server->save();
        } */

        return 0;
    }
}
