local ConnectionsHandler = {}
ConnectionsHandler.__index = ConnectionsHandler

wax.shared.Connections = {}

function ConnectionsHandler:GiveSignal(Signal:RBXScriptSignal, fn:AnyFunction) : (RBXScriptConnection)
    assert(typeof(Signal) == 'RBXScriptSignal', 'Expected RBXScriptSignal, got '..typeof(Signal))
    assert(typeof(fn) == 'function', 'Expected function, got '..typeof(fn))

    local Connection = Signal:Connect(fn)
    table.insert(wax.shared.Connections, Connection)
    return Connection
end

return ConnectionsHandler