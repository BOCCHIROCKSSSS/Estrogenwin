local Signal = {}
Signal.__index = Signal

local Connection = {}
Connection.__index = Connection

function Connection.new(signal, handler)
	return setmetatable({
		_handler = handler,
		_signal = signal,
	}, Connection)
end

function Connection:Disconnect()
	self._signal[self] = nil
end

function Signal.new()
	return setmetatable({}, Signal)
end

function Signal:Connect(fn)
	local connection = Connection.new(self, fn)
	self[connection] = true
	return connection
end

function Signal:DisconnectAll()
	table.clear(self)
end

function Signal:Fire(...)
	if next(self) then
		for handler, _ in pairs(self) do
			handler._handler(...)
		end
	end
end

function Signal:Wait()
	local waitingCoroutine = coroutine.running()
	local cn;
	cn = self:Connect(function(...)
		cn:Disconnect()
		task.spawn(waitingCoroutine, ...)
	end)
	return coroutine.yield()
end

function Signal:Once(fn)
	local cn;
	cn = self:Connect(function(...)
		cn:Disconnect()
		fn(...)
	end)
	return cn
end

return Signal
