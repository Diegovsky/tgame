function love.conf(t)
  package.cpath = 'lib/?.so;lib/?.dll;'..package.cpath
end
