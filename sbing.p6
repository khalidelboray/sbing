use lib 'lib';
use Bing;
use JSON::Fast;
use URI;
use Net::DNS;
multi sub MAIN (
    :$search , #= Querey Bing.com for urls - takes no value
    Str:D :$keyword! , #= Keyword to use as a Querey - required with --search
    Int:D :$pages = 10 , #= Number of pages to proccess - optional defaults to 10 
    Str :$out = 'output' , #= Output file name - optional defaults to output .txt/.json
    Bool :$json = False , #= Pass this param to add a 'output.json' with results 
    Bool :$info = False , #= Get urls info (domain,ip address,path,params) if found any will write json file
) {
    my $b = Bing.new(keyword => $keyword , pages => $pages );
    my %out = $b.search;
    my $out-file = $out.split( '.' )[0]; 
    if $info {
        for %out{'urls'}.keys -> $url {
            my $uri = URI.new($url);
            my $resolver = Net::DNS.new('8.8.8.8');
            my $ip = ~$resolver.lookup-ips($uri.host, :inet);
            my $cname = ~$resolver.lookup( 'CNAME' , $uri.host);
            %out{'hosts'}{$uri.host}{'ips'} = [];
            %out{'hosts'}{$uri.host}{'ips'}.push: $ip;
            %out{'hosts'}{$uri.host}{'ips'} =  %out{'hosts'}{$uri.host}{'ips'}.unique;
            %out{'hosts'}{$uri.host}{'CNAME'} = $cname if $cname;
            %out{'hosts'}{$uri.host}{'paths'}{$uri.path} = Hash.new;
            %out{'hosts'}{$uri.host}{'paths'}{$uri.path}{'params'}.append($uri.query-form.keys) if $uri.query;
        }
        ($out-file ~ '.json').IO.spurt( to-json %out);
    } else {
        $json ?? ($out-file ~ '.json').IO.spurt( to-json %out) !! ($out-file ~ '.txt').IO.spurt(%out{'urls'}.keys.join("\n")) ;
    }
}
