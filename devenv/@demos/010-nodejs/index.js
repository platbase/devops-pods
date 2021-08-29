const _ = require('loadsh');
const dayjs = require('dayjs');
const colors = require('colors-console')

const _log = function(... msgs){
    var time = dayjs().format('YYYY-MM-DD HH:mm:ss SSS');
    console.log(colors('green', `[${time}]`), ... msgs);
}

// camelCase
var src = "this-is-my-test";
var result = _.camelCase("this-is-my-test");
_log(`${src} --> ${result}`);
