
local mysql = require("resty.mysql")


--创建mysql连接实例
local db, err = mysql:new()
if not db then
    ngx.say("new mysql error : ", err)
    return
end
--设置超时时间(毫秒)
db:set_timeout(1000)

-- 定义链接属性
local props = {
    host = "127.0.0.1",
    port = 3306,
    database = "lua_test",
    user = "root",
    password = "yk123"
}

-- 发起连接
local res, err, errno, sqlstate = db:connect(props)

if not res then
    ngx.say("connect to mysql error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
    return close_db(db)
end



--查询
local select_sql = "SELECT * FROM `user`"
res, err, errno, sqlstate = db:query(select_sql)
if not res then
    ngx.say("select error : ", err, " , errno : ", errno, " , sqlstate : ", sqlstate)
    return close_db(db)
end

-- 结果集处理
for i, row in ipairs(res) do
    for name, value in pairs(row) do
        ngx.say("select row ", i, " : ", name, " = ", value, "<br/>")
    end
end

-- 关闭mysql链接
local function close_db(db)
    if not db then
        return
    end
    db:close()
end

close_db(db)
