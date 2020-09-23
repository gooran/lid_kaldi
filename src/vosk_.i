%module(package="vosk") vosk

%include <typemaps.i>
%include <std_string.i>

#if SWIGPYTHON
%include <pybuffer.i>
#elif SWIGJAVA
%include <various.i>
#elif SWIGCSHARP
%include <arrays_csharp.i>
#endif

namespace kaldi {
    namespace nnet3 {
    }
}

#if SWIGPYTHON
%pybuffer_binary(const char *data, int len);
%ignore KaldiRecognizer::AcceptWaveform(const short *sdata, int len);
%ignore KaldiRecognizer::AcceptWaveform(const float *fdata, int len);
%exception {
  try {
    $action
  } catch (kaldi::KaldiFatalError &e) {
    PyErr_SetString(PyExc_RuntimeError, const_cast<char*>(e.KaldiMessage()));
    SWIG_fail;
  } catch (std::exception &e) {
    PyErr_SetString(PyExc_RuntimeError, const_cast<char*>(e.what()));
    SWIG_fail;
  }
}
#endif

#if SWIGJAVA
%apply char *BYTE {const char *data};
%ignore KaldiRecognizer::AcceptWaveform(const short *sdata, int len);
%ignore KaldiRecognizer::AcceptWaveform(const float *fdata, int len);
#endif

%{
#include "src/kaldi_recognizer.h"
#include "src/model.h"
#include "src/spk_model.h"
#include "src/lid_model.h"
#include "src/gpu.h"
%}

#if SWIGJAVA
%apply char *BYTE {const char *data};
%typemap(javaimports) KaldiRecognizer %{
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
%}
%typemap(javacode) KaldiRecognizer %{
  public boolean AcceptWaveform(byte[] data) {
    return AcceptWaveform(data, data.length);
  }
  public boolean AcceptWaveform(short[] data, int len) {
    byte[] bdata = new byte[len * 2];
    ByteBuffer.wrap(bdata).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().put(data, 0, len);
    return AcceptWaveform(bdata, bdata.length);
  }
%}
%pragma(java) jniclasscode=%{
    static {
        System.loadLibrary("vosk_jni_cpu");
    }
%}
#endif

#if SWIGCSHARP
CSHARP_ARRAYS(char, byte)
%apply char INPUT[] {const char *data};
%apply float INPUT[] {const float *fdata};
%apply short INPUT[] {const short *sdata};
#endif

%include "src/kaldi_recognizer.h"
%include "src/model.h"
%include "src/spk_model.h"
%include "src/lid_model.h"
%include "src/gpu.h"