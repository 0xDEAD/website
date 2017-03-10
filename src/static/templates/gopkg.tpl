{{/* Implement redirection for periph.io/x/... URLs */}}
{{- $path := .URL.Query.Get "path" -}}
{{- if len $path | ne 0 -}}
  {{- $repoName := index (.Split $path "/") 2 -}}
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="utf-8">
  {{- if eq $repoName "periph" -}}
    <meta name="go-import" content="periph.io/x/{{$repoName}} git https://github.com/google/{{$repoName}}" />
  {{- else -}}
    <meta name="go-import" content="periph.io/x/{{$repoName}} git https://github.com/periph/{{$repoName}}" />
  {{- end -}}
  <noscript>
    <meta name="destination" http-equiv="refresh" content="0; URL='https://godoc.org/periph.io{{$path}}'" />
  </noscript>
  <script>
    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
    (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
    m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
    })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');

    ga('create', 'UA-93006956-1', 'auto');
    ga('send', 'pageview');
  </script>
</head>
<body>Redirecting to <a href="https://godoc.org/periph.io{{$path}}">https://godoc.org/periph.io{{$path}}</a>...</body>
<script>
window.location.href = 'https://godoc.org/periph.io{{$path}}' + (window.location.search || '') + (window.location.hash || '');
</script>
</html>
{{- end -}}
