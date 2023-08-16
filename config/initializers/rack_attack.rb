class Rack::Attack
  throttle("req/ip", limit: 6, period: 30, &:ip)
end
