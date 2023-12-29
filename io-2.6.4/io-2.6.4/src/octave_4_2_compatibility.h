#if ! defined (OCTAVE_4_2_COMPATIBILITY_H_)
#define OCTAVE_4_2_COMPATIBILITY_H_ 1

#include <octave/version.h>

#if OCTAVE_MAJOR_VERSION == 4 && OCTAVE_MINOR_VERSION < 4
  #define iscell    is_cell
  #define isempty   is_empty
  #define isnumeric is_numeric_type
#endif

#endif
