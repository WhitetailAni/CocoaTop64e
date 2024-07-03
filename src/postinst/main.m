//
//  main.m
//  CocoaTop
//
//  Created by SXX on 2021/1/4.
//  Copyright © 2021 SXX. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <sys/stat.h>
#include <libroot.h>

#define APP_PATH_PREFIX "/Applications/CocoaTop.app"

char* append_string(const char* str1, const char* str2) {
    if (str1 == NULL || str2 == NULL) {
        return NULL;
    }

    size_t len1 = strlen(str1);
    size_t len2 = strlen(str2);
    
    char* result = malloc(len1 + len2 + 1);
    if (result == NULL) {
        return NULL;
    }

    strcpy(result, str1);
    strcat(result, str2);

    return result;
}


int main(int argc, char *argv[], char *envp[]) {
    char *appPath = libroot_dyn_jbrootpath("/Applications/CocoaTop.app", NULL);
    if (geteuid() != 0) {
        printf("ERROR: This tool needs to be run as root.\n");
        return 1;
    }
    chown(append_string(appPath, "/CocoaTop"), 0, 0);
    chmod(append_string(appPath, "/CocoaTop"), 04755);
    if (@available(iOS 10, *)) {
    } else {
        chmod(append_string(appPath, "/CocoaTop_"), 0755);
        rename(append_string(appPath, "/CocoaTop"), append_string(appPath, "/CocoaTop1"));
        rename(append_string(appPath, "/CocoaTop_"), append_string(appPath, "/CocoaTop"));
        rename(append_string(appPath, "/CocoaTop1"), append_string(appPath, "/CocoaTop_"));
    }
    return 0;
}
