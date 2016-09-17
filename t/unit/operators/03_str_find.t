use Test::Nginx::Socket::Lua;

repeat_each(3);
plan tests => repeat_each() * 3 * blocks();

no_shuffle();
run_tests();

__DATA__

=== TEST 1: Match (individual)
--- http_config
init_by_lua_block{
	if (os.getenv("LRW_COVERAGE")) then
		runner = require "luacov.runner"
		runner.tick = true
		runner.init({savestepsize = 50})
		jit.off()
	end
}
--- config
    location = /t {
        content_by_lua '
			local op    = require "resty.waf.operators"
			local match, value = op.str_find({ _pcre_flags = "" }, "hello, 1234", "hello")
			ngx.say(value)
		';
	}
--- request
GET /t
--- error_code: 200
--- response_body
hello
--- no_error_log
[error]

=== TEST 2: Match (table)
--- http_config
init_by_lua_block{
	if (os.getenv("LRW_COVERAGE")) then
		runner = require "luacov.runner"
		runner.tick = true
		runner.init({savestepsize = 50})
		jit.off()
	end
}
--- config
    location = /t {
        content_by_lua '
			local op    = require "resty.waf.operators"
			local match, value = op.str_find({ _pcre_flags = "" }, { "99-99-99", "	_\\\\", "hello, 1234"}, "hello")
			ngx.say(value)
		';
	}
--- request
GET /t
--- error_code: 200
--- response_body
hello
--- no_error_log
[error]

=== TEST 3: No match (individual)
--- http_config
init_by_lua_block{
	if (os.getenv("LRW_COVERAGE")) then
		runner = require "luacov.runner"
		runner.tick = true
		runner.init({savestepsize = 50})
		jit.off()
	end
}
--- config
    location = /t {
        content_by_lua '
			local op    = require "resty.waf.operators"
			local match, value = op.str_find({ _pcre_flags = "" }, "HELLO, 1234", "hello")
			ngx.say(match)
		';
	}
--- request
GET /t
--- error_code: 200
--- response_body
nil
--- no_error_log
[error]

=== TEST 4: No match (table)
--- http_config
init_by_lua_block{
	if (os.getenv("LRW_COVERAGE")) then
		runner = require "luacov.runner"
		runner.tick = true
		runner.init({savestepsize = 50})
		jit.off()
	end
}
--- config
    location = /t {
        content_by_lua '
			local op    = require "resty.waf.operators"
			local match, value = op.str_find({ _pcre_flags = "" }, { "99-99-99", "	_\\\\", "HELLO, 1234"}, "hello")
			ngx.say(match)
		';
	}
--- request
GET /t
--- error_code: 200
--- response_body
nil
--- no_error_log
[error]

=== TEST 5: Return values
--- http_config
init_by_lua_block{
	if (os.getenv("LRW_COVERAGE")) then
		runner = require "luacov.runner"
		runner.tick = true
		runner.init({savestepsize = 50})
		jit.off()
	end
}
--- config
    location = /t {
        content_by_lua '
			local op    = require "resty.waf.operators"
			local match, value = op.str_find({ _pcre_flags = "" }, "hello, 1234", "hello")
			ngx.say(match)
			ngx.say(value)
		';
	}
--- request
GET /t
--- error_code: 200
--- response_body
true
hello
--- no_error_log
[error]

=== TEST 7: Return value types
--- http_config
init_by_lua_block{
	if (os.getenv("LRW_COVERAGE")) then
		runner = require "luacov.runner"
		runner.tick = true
		runner.init({savestepsize = 50})
		jit.off()
	end
}
--- config
    location = /t {
        content_by_lua '
			local op    = require "resty.waf.operators"
			local match, value = op.str_find({ _pcre_flags = "" }, "hello, 1234", "hello")
			ngx.say(type(match))
			ngx.say(type(value))
		';
	}
--- request
GET /t
--- error_code: 200
--- response_body
boolean
string
--- no_error_log
[error]

