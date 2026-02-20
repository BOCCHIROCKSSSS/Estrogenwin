wax.shared.Hooks = {}

local HasOth = (getgenv()['oth'] ~= nil and true or false)

local HookMetaMethod = (HasOth and getgenv()['oth'].hook) or hookmetamethod
local RestoreFunction = (HasOth and getgenv()['oth'].unhook) or restorefunction

local IsHooked = (getgenv()['ishooked'] or getgenv()['isfunctionhooked']) or function(fn:AnyFunction)
    for _,Hook in wax.shared.Hooks do
        if Hook.OldFunction == fn then
            return true
        end
    end
    return false
end

local HookingService = {}
HookingService.__index = HookingService

function HookingService:HookMetaMethod(fn:AnyFunction, Metamethod:string)
    assert(typeof(fn) == 'function', 'Expected function, got '..typeof(fn))
    assert(typeof(Metamethod) == 'string', 'Expected string, got '..typeof(Metamethod))

    local OldHook; OldHook = HookMetaMethod(game, Metamethod, newcclosure(fn))
    table.insert(wax.shared.Hooks, {
        OldFunction = fn,
        Hook = OldHook,
    })
end

function HookingService:Unhook(fn:AnyFunction)
    assert(IsHooked(fn), 'Function is not hooked.')
    RestoreFunction(fn)
    for idx, Hook in wax.shared.Hooks do
        if Hook.OldFunction == fn then
            table.remove(wax.shared.Hooks, idx)
            break
        end
    end
end

return HookingService