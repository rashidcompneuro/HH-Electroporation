function Iapp = rectangular_input(t)
global ton toff
Iapp = (t >= ton) & (t <= toff);
end