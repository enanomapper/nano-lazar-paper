nano-lazar
==========

inline code

`! ruby test.rb`

normal code

`echo "normal code"`
`"4"`

results
-------

`! ruby results/weighted-average.rb`

referenzdaten!

pls mit original properties: katastrophal, egal ob -log10 oder nicht

local weighted average, -log10 transformed, no feature selection
rmse: 0.8585810024686744, mae: 0.6785597520657844, r_squared: 0.508897016476696

local pls, -log10 transformed, no feature selection (calls weighted average)
rmse: 0.8992939561572298, mae: 0.7204175044919703, r_squared: 0.6563666334054629

local weighted avarage, -log10 transformed, feature selection

pls with scaled properties

