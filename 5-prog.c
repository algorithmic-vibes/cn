#include <stdio.h>
#include <string.h>

// generator polynomial length
#define N strlen(gen_poly)

// data to be transmitted and received
char data[28];

// CRC value
char check_value[28];

// generator polynomial
char gen_poly[10];

// variables
int data_length, i, j;

// XOR operation
void XOR() {
    // if both bits are same -> 0
    // if different -> 1
    for (j = 1; j < N; j++)
        check_value[j] = ((check_value[j] == gen_poly[j]) ? '0' : '1');
}

// CRC computation
void crc() {
    // initialize check_value with first N bits
    for (i = 0; i < N; i++)
        check_value[i] = data[i];

    do {
        // perform XOR if leftmost bit is 1
        if (check_value[0] == '1')
            XOR();

        // left shift by 1
        for (j = 0; j < N - 1; j++)
            check_value[j] = check_value[j + 1];

        // append next data bit
        check_value[j] = data[i++];

    } while (i <= data_length + N - 1);
}

// receiver side error checking
void receiver() {
    printf("Enter the received data: ");
    scanf("%s", data);

    printf("\n\nData received: %s", data);

    // compute CRC again
    crc();

    // check for errors
    for (i = 0; (i < N - 1) && (check_value[i] != '1'); i++);

    if (i < N - 1)
        printf("\nError detected\n\n");
    else
        printf("\nNo error detected\n\n");
}

int main() {
    // get data
    printf("\nEnter data to be transmitted: ");
    scanf("%s", data);

    // get generator polynomial
    printf("\nEnter the Generating polynomial: ");
    scanf("%s", gen_poly);

    // original data length
    data_length = strlen(data);

    // append N-1 zeros
    for (i = data_length; i < data_length + N - 1; i++)
        data[i] = '0';
    data[i] = '\0';

    printf("\nData padded with n-1 zeros: %s\n", data);

    // compute CRC
    crc();

    // print CRC
    printf("CRC or Check value is: %s\n", check_value);

    // append CRC to data
    for (i = data_length; i < data_length + N - 1; i++)
        data[i] = check_value[i - data_length];
    data[data_length + N - 1] = '\0';

    printf("Final data to be sent: %s\n\n", data);

    // receiver checks the data
    receiver();

    return 0;
}
