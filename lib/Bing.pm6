unit class Bing;
use HTTP::UserAgent;
has Str $.keyword is rw is required;
has Int $.pages is rw = 10;
has Str $.ua-str is rw = 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:29.0) Gecko/20100101 Firefox/29.0';
has %.result is rw;
has HTTP::UserAgent $.ua is rw = HTTP::UserAgent.new( useragent => $!ua-str );
method search () {
   my @pages = [0.. $.pages - 1]>>.&{ +($_ ~ '1') }.map({
        'http://www.bing.com/search?q=' ~ $.keyword ~ '&count=10' ~ '&first=' ~ $_ ~ '&FORM=PERE' });
    loop {
        my @promises;
        while ( @pages ) {
            my $url = @pages.shift;
            my $p = Promise.start({self.proccess($url)});
            @promises.push($p);
        }
        await Promise.allof(@promises);
                if @pages.elems == 0 {
            last;
        }
    }
    return %.result;
}
method proccess ($url) {
    my $res = $.ua.get($url);
    my @urls =  $res.content.match(/ '<h2><a href="' (<-[ " ]> *)  '"'/,:global)>>.&{ ~$_[0] };
    for @urls -> $url {
        %.result{'urls'}{$url}++;
    }
}
