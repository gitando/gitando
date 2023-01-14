<!DOCTYPE html>
<html>
<head>
    <title>{{ $domain }}</title>
    <style>
        body {
            font-family: Arial, Helvetica, sans-serif;
        }
    </style>
</head>
<body>
	<center>
		<h4>{{ strtoupper(__('gitando.site')) }}</h4>
		<h1>{{ $domain }}</h1>
    </center>
	<br>
    <h3>SSH/SFTP</h3>
	<ul>
		<li><b>{{ __('gitando.host') }}</b> {{$ip}}</li>
		<li><b>{{ __('gitando.port') }}</b> 22</li>
		<li><b>{{ __('gitando.username') }}</b> {{$username}}</li>
        <li><b>{{ __('gitando.password') }}</b> {{$password}}</li>
        <li><b>{{ __('gitando.path') }}</b> /home/{{ $username }}/web/{{ $path }}</li>
	</ul>
	<br>
	<hr>
	<br>
	<h3>{{ __('gitando.database') }}</h3>
	<ul>
		<li><b>{{ __('gitando.host') }}</b> 127.0.0.1</li>
		<li><b>{{ __('gitando.port') }}</b> 3306</li>
		<li><b>{{ __('gitando.username') }}</b> {{$username}}</li>
		<li><b>{{ __('gitando.password') }}</b> {{$dbpass}}</li>
		<li><b>{{ __('gitando.name') }}</b> {{$username}}</li>
    </ul>
    <br>
	<hr>
    <br>
    <center>
        <p>{!! __('gitando.pdf_site_php_version', ['domain' => $domain, 'php' => $php]) !!}</p>
    </center>
    <br>
	<center>
		<p>{{ __('gitando.pdf_take_care') }}</p>
	</center>
    <br>
    <br>
	<br>
	<center>
		<h5>{{ config('gitando.name') }}<br>({{ config('gitando.website') }})</h5>
	</center>
</body>
</html>
