# == Class: template
#
# Use as template

class template (
  $var1 = 'USE_DEFAULTS',
  $var2 = 'USE_DEFAULTS',
  $var3 = '242',
) {

  # <define os default values>
  # Set $os_defaults_missing to true for unspecified osfamilies
  case $::osfamily {
    'RedHat': {
      $var1_default = 'RedHat default 1'
      $var2_default = true
    }
    'Suse': {
      $var1_default = 'Suse default 1'
      $var2_default = true
    }
    'Solaris': {
      $var1_default = 'Solaris default 1'
      $var2_default = false
    }
    default: {
      $os_defaults_missing = true
    }
  }
  # </define os default values>


  # <USE_DEFAULT vs OS defaults>
  # Check if 'USE_DEFAULTS' is used anywhere without having OS default value
  if (
    ($var1 == 'USE_DEFAULTS') or
    ($var2 == 'USE_DEFAULTS')
  ) and $os_defaults_missing == true {
      fail("Sorry, I don't know default values for $::osfamily yet :( Please provide specific values to the template module.")
  }
  # </USE_DEFAULT vs OS defaults>


  # <assign variables>
  # Change 'USE_DEFAULTS' to OS specific default values
  # Convert strings with booleans to real boolean, if needed
  # Create *_real variables for the rest too

  $var1_real = $var1 ? {
    'USE_DEFAULTS' => $var1_default,
    default        => $var1
  }

  if type($var2) == 'boolean' {
    $var2_real = $var2
  } else {
    $var2_real = $var2 ? {
      'USE_DEFAULTS' => $var2_default,
      default        => str2bool($var2)
    }
  }

  $var3_real = $var3

  # </assign variables>


  # <validating variables>

  # allows only strings if not undef
  if $var1_real != undef {
    validate_string($var1_real)
  }

  # allows only bools
  validate_bool($var2_real)

  # allows only numbers if not undef
  if ($var3_real != undef) and (is_numeric($var3_real) != true) {
    fail('Only numbers are allowed in the template::var3 param.')
  }

  # allows only given words if not undef
  if $var3_real != undef {
    validate_re($var3_real, '^(daily)|(weekly)|(specific)$', 'Only <daily>, <weekly> and <specific> are allowed in the template::var3 param.')
  }

  # allows only absolute paths
  validate_absolute_path($var3_real)

  # allows only integers
  if !is_integer($var3_real) {
    fail('Only integers are allowed in the template::var3 param.')
  }

  # </validating variables>


  # <Do Stuff>
  # </Done Stuff>

}
