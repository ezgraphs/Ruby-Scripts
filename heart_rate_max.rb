# Heart Rate Max: 

HR_MAX_CALC={
  1, 'Traditional',
  2, 'Least objectionable',
  3, 'Londeree and Moeschberger',
  4, 'Miller et al from Indiana University',
  5, 'Tanaka method',
  6, 'Lund and Sweden - men',
  7, 'Oakland University 2007 nonlinear',
  8, 'Martha Gulati et al - women',
  9, 'Lund and Sweden -women'
}

def hr_max(age, method=1)
  return 220 - age if method == 1 # Traditional
  return 205.8 - (0.685 * age) if method==2 # Least objectionable
  return 206.3 - (0.711 * age) if method==3 #Londeree and Moeschberger
  return 217.0 - (0.85  * age) if method==4  # Miller et al. from Indiana University
  return 208.0 - (0.7 * age) if method==5  # Tanaka method
  return 203.7 / (1 + Math.exp(0.033 * (age - 104.3))) if method ==6 # Lund, Sweden (for men)
  return 191.5 - (0.007 * age**2) if method==7 # Oakland Non-linear  
  return 206.0 - (0.88 * age) if method==8 # Martha Gulati et al (for women)
  return 190.2/(1 + Math.exp(0.0453 * (age - 107.5))) if method==9 # Lund, Sweden (for women)
end

File.open('heart_rate_max.csv','w'){|f|
  f.print('Age')
  1.upto(9){|i|f.print ";#{HR_MAX_CALC[i].gsub(' ','_')}"}
  f.puts
  18.upto(90){|a|
    f.print a
    1.upto(9){|i|f.print ";#{hr_max(a,i)}"}
    f.puts
  }
} 