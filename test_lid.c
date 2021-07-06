//
// Created by sitdikov on 23.09.20.
//

#include "native/lid_api.h"
#include <stdio.h>

int main() {

    char ch_arr[1][29] = {
        "003F02.wav"
    };

    L2mLidModel *lid_model = l2m_lid_model_new("spk-model");

    for(int i = 0; i < 1; i++) {
        L2mRecognizer *recognizer = l2m_recognizer_new_lid(lid_model, 8000.0);
        FILE *wavin;
        int nread, final;
        if (fopen((const  char *)(ch_arr + i), "rb") != NULL) {
            wavin = fopen((const  char *)(ch_arr + i), "rb");
            fseek(wavin, 0L, SEEK_END);
            long sz = ftell(wavin);
            fseek(wavin, 0L, SEEK_SET);
            char buf[sz - 44];
            fseek(wavin, 44, SEEK_SET);

            nread = fread(buf, 1, sizeof(buf), wavin);
            l2m_recognizer_accept_waveform(recognizer, buf, nread);
            printf("%s\n", l2m_recognizer_lang_result(recognizer));

            l2m_recognizer_free(recognizer);

            fclose(wavin);
        }
    }

    l2m_lid_model_free(lid_model);

    return 0;
}
