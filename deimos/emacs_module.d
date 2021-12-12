


        import core.stdc.config;
        import core.stdc.stdarg: va_list;
        static import core.simd;
        static import std.conv;

        struct Int128 { long lower; long upper; }
        struct UInt128 { ulong lower; ulong upper; }

        struct __locale_data { int dummy; } // FIXME



alias _Bool = bool;
struct dpp {
    static struct Opaque(int N) {
        void[N] bytes;
    }
    // Replacement for the gcc/clang intrinsic
    static bool isEmpty(T)() {
        return T.tupleof.length == 0;
    }
    static struct Move(T) {
        T* ptr;
    }
    // dmd bug causes a crash if T is passed by value.
    // Works fine with ldc.
    static auto move(T)(ref T value) {
        return Move!T(&value);
    }
    mixin template EnumD(string name, T, string prefix) if(is(T == enum)) {
        private static string _memberMixinStr(string member) {
            import std.conv: text;
            import std.array: replace;
            return text(` `, member.replace(prefix, ""), ` = `, T.stringof, `.`, member, `,`);
        }
        private static string _enumMixinStr() {
            import std.array: join;
            string[] ret;
            ret ~= "enum " ~ name ~ "{";
            static foreach(member; __traits(allMembers, T)) {
                ret ~= _memberMixinStr(member);
            }
            ret ~= "}";
            return ret.join("\n");
        }
        mixin(_enumMixinStr());
    }
}

extern(C)
{

    alias timer_t = void*;

    alias time_t = c_long;

    struct tm
    {

        int tm_sec;

        int tm_min;

        int tm_hour;

        int tm_mday;

        int tm_mon;

        int tm_year;

        int tm_wday;

        int tm_yday;

        int tm_isdst;

        c_long tm_gmtoff;

        const(char)* tm_zone;
    }

    struct timespec
    {

        c_long tv_sec;

        c_long tv_nsec;
    }

    struct itimerspec
    {

        timespec it_interval;

        timespec it_value;
    }

    alias locale_t = __locale_struct*;

    alias clockid_t = int;

    alias clock_t = c_long;

    alias __locale_t = __locale_struct*;

    struct __locale_struct
    {

        __locale_data*[13] __locales;

        const(ushort)* __ctype_b;

        const(int)* __ctype_tolower;

        const(int)* __ctype_toupper;

        const(char)*[13] __names;
    }

    alias __sig_atomic_t = int;

    alias __socklen_t = uint;

    alias __intptr_t = c_long;

    alias __caddr_t = char*;

    alias __loff_t = c_long;

    alias __syscall_ulong_t = c_ulong;

    alias __syscall_slong_t = c_long;

    alias __ssize_t = c_long;

    alias __fsword_t = c_long;

    alias __fsfilcnt64_t = c_ulong;

    alias __fsfilcnt_t = c_ulong;

    alias __fsblkcnt64_t = c_ulong;

    alias __fsblkcnt_t = c_ulong;

    alias __blkcnt64_t = c_long;

    alias __blkcnt_t = c_long;

    alias __blksize_t = c_long;

    alias __timer_t = void*;

    alias __clockid_t = int;

    alias __key_t = int;

    alias __daddr_t = int;

    alias __suseconds_t = c_long;

    alias __useconds_t = uint;

    alias __time_t = c_long;

    alias __id_t = uint;

    alias __rlim64_t = c_ulong;

    alias __rlim_t = c_ulong;

    alias __clock_t = c_long;

    struct __fsid_t
    {

        int[2] __val;
    }

    alias __pid_t = int;

    alias __off64_t = c_long;

    alias __off_t = c_long;

    alias __nlink_t = c_ulong;

    alias __mode_t = uint;

    alias __ino64_t = c_ulong;

    alias __ino_t = c_ulong;

    alias __gid_t = uint;

    alias __uid_t = uint;

    alias __dev_t = c_ulong;

    alias __uintmax_t = c_ulong;

    alias __intmax_t = c_long;

    alias __u_quad_t = c_ulong;

    alias __quad_t = c_long;

    alias __uint_least64_t = c_ulong;

    alias __int_least64_t = c_long;

    alias __uint_least32_t = uint;

    alias __int_least32_t = int;

    alias __uint_least16_t = ushort;

    alias __int_least16_t = short;

    alias __uint_least8_t = ubyte;

    alias __int_least8_t = byte;

    alias __uint64_t = c_ulong;

    alias __int64_t = c_long;

    alias __uint32_t = uint;

    alias __int32_t = int;

    alias __uint16_t = ushort;

    alias __int16_t = short;

    alias __uint8_t = ubyte;

    alias __int8_t = byte;

    alias __u_long = c_ulong;

    alias __u_int = uint;

    alias __u_short = ushort;

    alias __u_char = ubyte;

    alias uint64_t = ulong;

    alias uint32_t = uint;

    alias uint16_t = ushort;

    alias uint8_t = ubyte;

    alias int64_t = c_long;

    alias int32_t = int;

    alias int16_t = short;

    alias int8_t = byte;

    int timespec_get(timespec*, int) @nogc nothrow;

    int timer_getoverrun(void*) @nogc nothrow;

    int timer_gettime(void*, itimerspec*) @nogc nothrow;

    int timer_settime(void*, int, const(itimerspec)*, itimerspec*) @nogc nothrow;

    int timer_delete(void*) @nogc nothrow;

    int timer_create(int, sigevent*, void**) @nogc nothrow;

    int clock_getcpuclockid(int, int*) @nogc nothrow;

    int clock_nanosleep(int, int, const(timespec)*, timespec*) @nogc nothrow;

    int clock_settime(int, const(timespec)*) @nogc nothrow;

    int clock_gettime(int, timespec*) @nogc nothrow;

    int clock_getres(int, timespec*) @nogc nothrow;

    int nanosleep(const(timespec)*, timespec*) @nogc nothrow;

    int dysize(int) @nogc nothrow;

    c_long timelocal(tm*) @nogc nothrow;

    c_long timegm(tm*) @nogc nothrow;

    extern __gshared c_long timezone;

    extern __gshared int daylight;

    void tzset() @nogc nothrow;

    extern __gshared char*[2] tzname;

    extern __gshared c_long __timezone;

    extern __gshared int __daylight;

    extern __gshared char*[2] __tzname;

    char* ctime_r(const(c_long)*, char*) @nogc nothrow;

    char* asctime_r(const(tm)*, char*) @nogc nothrow;

    char* ctime(const(c_long)*) @nogc nothrow;

    char* asctime(const(tm)*) @nogc nothrow;

    tm* localtime_r(const(c_long)*, tm*) @nogc nothrow;

    tm* gmtime_r(const(c_long)*, tm*) @nogc nothrow;

    tm* localtime(const(c_long)*) @nogc nothrow;

    tm* gmtime(const(c_long)*) @nogc nothrow;

    c_ulong strftime_l(char*, c_ulong, const(char)*, const(tm)*, __locale_struct*) @nogc nothrow;

    c_ulong strftime(char*, c_ulong, const(char)*, const(tm)*) @nogc nothrow;

    c_long mktime(tm*) @nogc nothrow;

    double difftime(c_long, c_long) @nogc nothrow;

    c_long time(c_long*) @nogc nothrow;

    c_long clock() @nogc nothrow;

    alias emacs_env = emacs_env_27;

    struct emacs_env_27
    {

        c_long size;

        emacs_env_private* private_members;

        emacs_value_tag* function(emacs_env_27*, emacs_value_tag*) make_global_ref;

        void function(emacs_env_27*, emacs_value_tag*) free_global_ref;

        emacs_funcall_exit function(emacs_env_27*) non_local_exit_check;

        void function(emacs_env_27*) non_local_exit_clear;

        emacs_funcall_exit function(emacs_env_27*, emacs_value_tag**, emacs_value_tag**) non_local_exit_get;

        void function(emacs_env_27*, emacs_value_tag*, emacs_value_tag*) non_local_exit_signal;

        void function(emacs_env_27*, emacs_value_tag*, emacs_value_tag*) non_local_exit_throw;

        emacs_value_tag* function(emacs_env_27*, c_long, c_long, emacs_value_tag* function(emacs_env_27*, c_long, emacs_value_tag**, void*), const(char)*, void*) make_function;

        emacs_value_tag* function(emacs_env_27*, emacs_value_tag*, c_long, emacs_value_tag**) funcall;

        emacs_value_tag* function(emacs_env_27*, const(char)*) intern;

        emacs_value_tag* function(emacs_env_27*, emacs_value_tag*) type_of;

        bool function(emacs_env_27*, emacs_value_tag*) is_not_nil;

        bool function(emacs_env_27*, emacs_value_tag*, emacs_value_tag*) eq;

        c_long function(emacs_env_27*, emacs_value_tag*) extract_integer;

        emacs_value_tag* function(emacs_env_27*, c_long) make_integer;

        double function(emacs_env_27*, emacs_value_tag*) extract_float;

        emacs_value_tag* function(emacs_env_27*, double) make_float;

        bool function(emacs_env_27*, emacs_value_tag*, char*, c_long*) copy_string_contents;

        emacs_value_tag* function(emacs_env_27*, const(char)*, c_long) make_string;

        emacs_value_tag* function(emacs_env_27*, void function(void*), void*) make_user_ptr;

        void* function(emacs_env_27*, emacs_value_tag*) get_user_ptr;

        void function(emacs_env_27*, emacs_value_tag*, void*) set_user_ptr;

        void function(void*) function(emacs_env_27*, emacs_value_tag*) get_user_finalizer;

        void function(emacs_env_27*, emacs_value_tag*, void function(void*)) set_user_finalizer;

        emacs_value_tag* function(emacs_env_27*, emacs_value_tag*, c_long) vec_get;

        void function(emacs_env_27*, emacs_value_tag*, c_long, emacs_value_tag*) vec_set;

        c_long function(emacs_env_27*, emacs_value_tag*) vec_size;

        bool function(emacs_env_27*) should_quit;

        emacs_process_input_result function(emacs_env_27*) process_input;

        timespec function(emacs_env_27*, emacs_value_tag*) extract_time;

        emacs_value_tag* function(emacs_env_27*, timespec) make_time;

        bool function(emacs_env_27*, emacs_value_tag*, int*, c_long*, c_ulong*) extract_big_integer;

        emacs_value_tag* function(emacs_env_27*, int, c_long, const(c_ulong)*) make_big_integer;
    }

    alias emacs_value = emacs_value_tag*;
    struct emacs_value_tag;

    enum _Anonymous_0
    {

        emacs_variadic_function = -2,
    }
    enum emacs_variadic_function = _Anonymous_0.emacs_variadic_function;

    struct emacs_runtime
    {

        c_long size;

        emacs_runtime_private* private_members;

        emacs_env_27* function(emacs_runtime*) get_environment;
    }

    enum emacs_funcall_exit
    {

        emacs_funcall_exit_return = 0,

        emacs_funcall_exit_signal = 1,

        emacs_funcall_exit_throw = 2,
    }
    enum emacs_funcall_exit_return = emacs_funcall_exit.emacs_funcall_exit_return;
    enum emacs_funcall_exit_signal = emacs_funcall_exit.emacs_funcall_exit_signal;
    enum emacs_funcall_exit_throw = emacs_funcall_exit.emacs_funcall_exit_throw;

    enum emacs_process_input_result
    {

        emacs_process_input_continue = 0,

        emacs_process_input_quit = 1,
    }
    enum emacs_process_input_continue = emacs_process_input_result.emacs_process_input_continue;
    enum emacs_process_input_quit = emacs_process_input_result.emacs_process_input_quit;

    alias emacs_limb_t = c_ulong;

    struct emacs_env_25
    {

        c_long size;

        emacs_env_private* private_members;

        emacs_value_tag* function(emacs_env_27*, emacs_value_tag*) make_global_ref;

        void function(emacs_env_27*, emacs_value_tag*) free_global_ref;

        emacs_funcall_exit function(emacs_env_27*) non_local_exit_check;

        void function(emacs_env_27*) non_local_exit_clear;

        emacs_funcall_exit function(emacs_env_27*, emacs_value_tag**, emacs_value_tag**) non_local_exit_get;

        void function(emacs_env_27*, emacs_value_tag*, emacs_value_tag*) non_local_exit_signal;

        void function(emacs_env_27*, emacs_value_tag*, emacs_value_tag*) non_local_exit_throw;

        emacs_value_tag* function(emacs_env_27*, c_long, c_long, emacs_value_tag* function(emacs_env_27*, c_long, emacs_value_tag**, void*), const(char)*, void*) make_function;

        emacs_value_tag* function(emacs_env_27*, emacs_value_tag*, c_long, emacs_value_tag**) funcall;

        emacs_value_tag* function(emacs_env_27*, const(char)*) intern;

        emacs_value_tag* function(emacs_env_27*, emacs_value_tag*) type_of;

        bool function(emacs_env_27*, emacs_value_tag*) is_not_nil;

        bool function(emacs_env_27*, emacs_value_tag*, emacs_value_tag*) eq;

        c_long function(emacs_env_27*, emacs_value_tag*) extract_integer;

        emacs_value_tag* function(emacs_env_27*, c_long) make_integer;

        double function(emacs_env_27*, emacs_value_tag*) extract_float;

        emacs_value_tag* function(emacs_env_27*, double) make_float;

        bool function(emacs_env_27*, emacs_value_tag*, char*, c_long*) copy_string_contents;

        emacs_value_tag* function(emacs_env_27*, const(char)*, c_long) make_string;

        emacs_value_tag* function(emacs_env_27*, void function(void*), void*) make_user_ptr;

        void* function(emacs_env_27*, emacs_value_tag*) get_user_ptr;

        void function(emacs_env_27*, emacs_value_tag*, void*) set_user_ptr;

        void function(void*) function(emacs_env_27*, emacs_value_tag*) get_user_finalizer;

        void function(emacs_env_27*, emacs_value_tag*, void function(void*)) set_user_finalizer;

        emacs_value_tag* function(emacs_env_27*, emacs_value_tag*, c_long) vec_get;

        void function(emacs_env_27*, emacs_value_tag*, c_long, emacs_value_tag*) vec_set;

        c_long function(emacs_env_27*, emacs_value_tag*) vec_size;
    }

    struct emacs_env_26
    {

        c_long size;

        emacs_env_private* private_members;

        emacs_value_tag* function(emacs_env_27*, emacs_value_tag*) make_global_ref;

        void function(emacs_env_27*, emacs_value_tag*) free_global_ref;

        emacs_funcall_exit function(emacs_env_27*) non_local_exit_check;

        void function(emacs_env_27*) non_local_exit_clear;

        emacs_funcall_exit function(emacs_env_27*, emacs_value_tag**, emacs_value_tag**) non_local_exit_get;

        void function(emacs_env_27*, emacs_value_tag*, emacs_value_tag*) non_local_exit_signal;

        void function(emacs_env_27*, emacs_value_tag*, emacs_value_tag*) non_local_exit_throw;

        emacs_value_tag* function(emacs_env_27*, c_long, c_long, emacs_value_tag* function(emacs_env_27*, c_long, emacs_value_tag**, void*), const(char)*, void*) make_function;

        emacs_value_tag* function(emacs_env_27*, emacs_value_tag*, c_long, emacs_value_tag**) funcall;

        emacs_value_tag* function(emacs_env_27*, const(char)*) intern;

        emacs_value_tag* function(emacs_env_27*, emacs_value_tag*) type_of;

        bool function(emacs_env_27*, emacs_value_tag*) is_not_nil;

        bool function(emacs_env_27*, emacs_value_tag*, emacs_value_tag*) eq;

        c_long function(emacs_env_27*, emacs_value_tag*) extract_integer;

        emacs_value_tag* function(emacs_env_27*, c_long) make_integer;

        double function(emacs_env_27*, emacs_value_tag*) extract_float;

        emacs_value_tag* function(emacs_env_27*, double) make_float;

        bool function(emacs_env_27*, emacs_value_tag*, char*, c_long*) copy_string_contents;

        emacs_value_tag* function(emacs_env_27*, const(char)*, c_long) make_string;

        emacs_value_tag* function(emacs_env_27*, void function(void*), void*) make_user_ptr;

        void* function(emacs_env_27*, emacs_value_tag*) get_user_ptr;

        void function(emacs_env_27*, emacs_value_tag*, void*) set_user_ptr;

        void function(void*) function(emacs_env_27*, emacs_value_tag*) get_user_finalizer;

        void function(emacs_env_27*, emacs_value_tag*, void function(void*)) set_user_finalizer;

        emacs_value_tag* function(emacs_env_27*, emacs_value_tag*, c_long) vec_get;

        void function(emacs_env_27*, emacs_value_tag*, c_long, emacs_value_tag*) vec_set;

        c_long function(emacs_env_27*, emacs_value_tag*) vec_size;

        bool function(emacs_env_27*) should_quit;
    }

    int emacs_module_init(emacs_runtime*) @nogc nothrow;

    struct max_align_t
    {

        long __clang_max_align_nonce1;

        real __clang_max_align_nonce2;
    }

    alias pid_t = int;
    struct sigevent;

    alias ptrdiff_t = c_long;

    alias size_t = c_ulong;

    alias wchar_t = int;

    alias uintmax_t = c_ulong;

    alias intmax_t = c_long;

    alias uintptr_t = c_ulong;

    alias intptr_t = c_long;

    alias uint_fast64_t = c_ulong;

    alias uint_fast32_t = c_ulong;

    alias uint_fast16_t = c_ulong;

    alias uint_fast8_t = ubyte;

    alias int_fast64_t = c_long;

    alias int_fast32_t = c_long;

    alias int_fast16_t = c_long;

    alias int_fast8_t = byte;

    alias uint_least64_t = c_ulong;

    alias uint_least32_t = uint;

    alias uint_least16_t = ushort;

    alias uint_least8_t = ubyte;

    alias int_least64_t = c_long;

    alias int_least32_t = int;

    alias int_least16_t = short;

    alias int_least8_t = byte;





    static if(!is(typeof(_STDINT_H))) {
        private enum enumMixinStr__STDINT_H = `enum _STDINT_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__STDINT_H); }))) {
            mixin(enumMixinStr__STDINT_H);
        }
    }




    static if(!is(typeof(_STDC_PREDEF_H))) {
        private enum enumMixinStr__STDC_PREDEF_H = `enum _STDC_PREDEF_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__STDC_PREDEF_H); }))) {
            mixin(enumMixinStr__STDC_PREDEF_H);
        }
    }






    static if(!is(typeof(__GLIBC_MINOR__))) {
        private enum enumMixinStr___GLIBC_MINOR__ = `enum __GLIBC_MINOR__ = 31;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_MINOR__); }))) {
            mixin(enumMixinStr___GLIBC_MINOR__);
        }
    }




    static if(!is(typeof(__GLIBC__))) {
        private enum enumMixinStr___GLIBC__ = `enum __GLIBC__ = 2;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC__); }))) {
            mixin(enumMixinStr___GLIBC__);
        }
    }




    static if(!is(typeof(__GNU_LIBRARY__))) {
        private enum enumMixinStr___GNU_LIBRARY__ = `enum __GNU_LIBRARY__ = 6;`;
        static if(is(typeof({ mixin(enumMixinStr___GNU_LIBRARY__); }))) {
            mixin(enumMixinStr___GNU_LIBRARY__);
        }
    }




    static if(!is(typeof(__GLIBC_USE_DEPRECATED_SCANF))) {
        private enum enumMixinStr___GLIBC_USE_DEPRECATED_SCANF = `enum __GLIBC_USE_DEPRECATED_SCANF = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_DEPRECATED_SCANF); }))) {
            mixin(enumMixinStr___GLIBC_USE_DEPRECATED_SCANF);
        }
    }




    static if(!is(typeof(__GLIBC_USE_DEPRECATED_GETS))) {
        private enum enumMixinStr___GLIBC_USE_DEPRECATED_GETS = `enum __GLIBC_USE_DEPRECATED_GETS = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_DEPRECATED_GETS); }))) {
            mixin(enumMixinStr___GLIBC_USE_DEPRECATED_GETS);
        }
    }




    static if(!is(typeof(__USE_FORTIFY_LEVEL))) {
        private enum enumMixinStr___USE_FORTIFY_LEVEL = `enum __USE_FORTIFY_LEVEL = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_FORTIFY_LEVEL); }))) {
            mixin(enumMixinStr___USE_FORTIFY_LEVEL);
        }
    }




    static if(!is(typeof(__USE_ATFILE))) {
        private enum enumMixinStr___USE_ATFILE = `enum __USE_ATFILE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ATFILE); }))) {
            mixin(enumMixinStr___USE_ATFILE);
        }
    }




    static if(!is(typeof(__USE_MISC))) {
        private enum enumMixinStr___USE_MISC = `enum __USE_MISC = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_MISC); }))) {
            mixin(enumMixinStr___USE_MISC);
        }
    }




    static if(!is(typeof(_ATFILE_SOURCE))) {
        private enum enumMixinStr__ATFILE_SOURCE = `enum _ATFILE_SOURCE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__ATFILE_SOURCE); }))) {
            mixin(enumMixinStr__ATFILE_SOURCE);
        }
    }




    static if(!is(typeof(__USE_XOPEN2K8))) {
        private enum enumMixinStr___USE_XOPEN2K8 = `enum __USE_XOPEN2K8 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_XOPEN2K8); }))) {
            mixin(enumMixinStr___USE_XOPEN2K8);
        }
    }




    static if(!is(typeof(__USE_ISOC99))) {
        private enum enumMixinStr___USE_ISOC99 = `enum __USE_ISOC99 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ISOC99); }))) {
            mixin(enumMixinStr___USE_ISOC99);
        }
    }




    static if(!is(typeof(__USE_ISOC95))) {
        private enum enumMixinStr___USE_ISOC95 = `enum __USE_ISOC95 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ISOC95); }))) {
            mixin(enumMixinStr___USE_ISOC95);
        }
    }




    static if(!is(typeof(__USE_XOPEN2K))) {
        private enum enumMixinStr___USE_XOPEN2K = `enum __USE_XOPEN2K = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_XOPEN2K); }))) {
            mixin(enumMixinStr___USE_XOPEN2K);
        }
    }




    static if(!is(typeof(__USE_POSIX199506))) {
        private enum enumMixinStr___USE_POSIX199506 = `enum __USE_POSIX199506 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX199506); }))) {
            mixin(enumMixinStr___USE_POSIX199506);
        }
    }




    static if(!is(typeof(__USE_POSIX199309))) {
        private enum enumMixinStr___USE_POSIX199309 = `enum __USE_POSIX199309 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX199309); }))) {
            mixin(enumMixinStr___USE_POSIX199309);
        }
    }




    static if(!is(typeof(__USE_POSIX2))) {
        private enum enumMixinStr___USE_POSIX2 = `enum __USE_POSIX2 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX2); }))) {
            mixin(enumMixinStr___USE_POSIX2);
        }
    }




    static if(!is(typeof(__USE_POSIX))) {
        private enum enumMixinStr___USE_POSIX = `enum __USE_POSIX = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX); }))) {
            mixin(enumMixinStr___USE_POSIX);
        }
    }






    static if(!is(typeof(_POSIX_C_SOURCE))) {
        private enum enumMixinStr__POSIX_C_SOURCE = `enum _POSIX_C_SOURCE = 200809L;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_C_SOURCE); }))) {
            mixin(enumMixinStr__POSIX_C_SOURCE);
        }
    }




    static if(!is(typeof(_POSIX_SOURCE))) {
        private enum enumMixinStr__POSIX_SOURCE = `enum _POSIX_SOURCE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__POSIX_SOURCE); }))) {
            mixin(enumMixinStr__POSIX_SOURCE);
        }
    }




    static if(!is(typeof(__USE_POSIX_IMPLICITLY))) {
        private enum enumMixinStr___USE_POSIX_IMPLICITLY = `enum __USE_POSIX_IMPLICITLY = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_POSIX_IMPLICITLY); }))) {
            mixin(enumMixinStr___USE_POSIX_IMPLICITLY);
        }
    }
    static if(!is(typeof(INT8_MIN))) {
        private enum enumMixinStr_INT8_MIN = `enum INT8_MIN = ( - 128 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT8_MIN); }))) {
            mixin(enumMixinStr_INT8_MIN);
        }
    }




    static if(!is(typeof(INT16_MIN))) {
        private enum enumMixinStr_INT16_MIN = `enum INT16_MIN = ( - 32767 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT16_MIN); }))) {
            mixin(enumMixinStr_INT16_MIN);
        }
    }




    static if(!is(typeof(INT32_MIN))) {
        private enum enumMixinStr_INT32_MIN = `enum INT32_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT32_MIN); }))) {
            mixin(enumMixinStr_INT32_MIN);
        }
    }




    static if(!is(typeof(INT64_MIN))) {
        private enum enumMixinStr_INT64_MIN = `enum INT64_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT64_MIN); }))) {
            mixin(enumMixinStr_INT64_MIN);
        }
    }




    static if(!is(typeof(INT8_MAX))) {
        private enum enumMixinStr_INT8_MAX = `enum INT8_MAX = ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT8_MAX); }))) {
            mixin(enumMixinStr_INT8_MAX);
        }
    }




    static if(!is(typeof(INT16_MAX))) {
        private enum enumMixinStr_INT16_MAX = `enum INT16_MAX = ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT16_MAX); }))) {
            mixin(enumMixinStr_INT16_MAX);
        }
    }




    static if(!is(typeof(INT32_MAX))) {
        private enum enumMixinStr_INT32_MAX = `enum INT32_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT32_MAX); }))) {
            mixin(enumMixinStr_INT32_MAX);
        }
    }




    static if(!is(typeof(INT64_MAX))) {
        private enum enumMixinStr_INT64_MAX = `enum INT64_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT64_MAX); }))) {
            mixin(enumMixinStr_INT64_MAX);
        }
    }




    static if(!is(typeof(UINT8_MAX))) {
        private enum enumMixinStr_UINT8_MAX = `enum UINT8_MAX = ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT8_MAX); }))) {
            mixin(enumMixinStr_UINT8_MAX);
        }
    }




    static if(!is(typeof(UINT16_MAX))) {
        private enum enumMixinStr_UINT16_MAX = `enum UINT16_MAX = ( 65535 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT16_MAX); }))) {
            mixin(enumMixinStr_UINT16_MAX);
        }
    }




    static if(!is(typeof(UINT32_MAX))) {
        private enum enumMixinStr_UINT32_MAX = `enum UINT32_MAX = ( 4294967295U );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT32_MAX); }))) {
            mixin(enumMixinStr_UINT32_MAX);
        }
    }




    static if(!is(typeof(UINT64_MAX))) {
        private enum enumMixinStr_UINT64_MAX = `enum UINT64_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT64_MAX); }))) {
            mixin(enumMixinStr_UINT64_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST8_MIN))) {
        private enum enumMixinStr_INT_LEAST8_MIN = `enum INT_LEAST8_MIN = ( - 128 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST8_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST8_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST16_MIN))) {
        private enum enumMixinStr_INT_LEAST16_MIN = `enum INT_LEAST16_MIN = ( - 32767 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST16_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST16_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST32_MIN))) {
        private enum enumMixinStr_INT_LEAST32_MIN = `enum INT_LEAST32_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST32_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST32_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST64_MIN))) {
        private enum enumMixinStr_INT_LEAST64_MIN = `enum INT_LEAST64_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST64_MIN); }))) {
            mixin(enumMixinStr_INT_LEAST64_MIN);
        }
    }




    static if(!is(typeof(INT_LEAST8_MAX))) {
        private enum enumMixinStr_INT_LEAST8_MAX = `enum INT_LEAST8_MAX = ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST8_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST8_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST16_MAX))) {
        private enum enumMixinStr_INT_LEAST16_MAX = `enum INT_LEAST16_MAX = ( 32767 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST16_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST16_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST32_MAX))) {
        private enum enumMixinStr_INT_LEAST32_MAX = `enum INT_LEAST32_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST32_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST32_MAX);
        }
    }




    static if(!is(typeof(INT_LEAST64_MAX))) {
        private enum enumMixinStr_INT_LEAST64_MAX = `enum INT_LEAST64_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_LEAST64_MAX); }))) {
            mixin(enumMixinStr_INT_LEAST64_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST8_MAX))) {
        private enum enumMixinStr_UINT_LEAST8_MAX = `enum UINT_LEAST8_MAX = ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST8_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST8_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST16_MAX))) {
        private enum enumMixinStr_UINT_LEAST16_MAX = `enum UINT_LEAST16_MAX = ( 65535 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST16_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST16_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST32_MAX))) {
        private enum enumMixinStr_UINT_LEAST32_MAX = `enum UINT_LEAST32_MAX = ( 4294967295U );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST32_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST32_MAX);
        }
    }




    static if(!is(typeof(UINT_LEAST64_MAX))) {
        private enum enumMixinStr_UINT_LEAST64_MAX = `enum UINT_LEAST64_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_LEAST64_MAX); }))) {
            mixin(enumMixinStr_UINT_LEAST64_MAX);
        }
    }




    static if(!is(typeof(INT_FAST8_MIN))) {
        private enum enumMixinStr_INT_FAST8_MIN = `enum INT_FAST8_MIN = ( - 128 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST8_MIN); }))) {
            mixin(enumMixinStr_INT_FAST8_MIN);
        }
    }




    static if(!is(typeof(INT_FAST16_MIN))) {
        private enum enumMixinStr_INT_FAST16_MIN = `enum INT_FAST16_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST16_MIN); }))) {
            mixin(enumMixinStr_INT_FAST16_MIN);
        }
    }




    static if(!is(typeof(INT_FAST32_MIN))) {
        private enum enumMixinStr_INT_FAST32_MIN = `enum INT_FAST32_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST32_MIN); }))) {
            mixin(enumMixinStr_INT_FAST32_MIN);
        }
    }




    static if(!is(typeof(INT_FAST64_MIN))) {
        private enum enumMixinStr_INT_FAST64_MIN = `enum INT_FAST64_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST64_MIN); }))) {
            mixin(enumMixinStr_INT_FAST64_MIN);
        }
    }




    static if(!is(typeof(INT_FAST8_MAX))) {
        private enum enumMixinStr_INT_FAST8_MAX = `enum INT_FAST8_MAX = ( 127 );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST8_MAX); }))) {
            mixin(enumMixinStr_INT_FAST8_MAX);
        }
    }




    static if(!is(typeof(__USE_ISOC11))) {
        private enum enumMixinStr___USE_ISOC11 = `enum __USE_ISOC11 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___USE_ISOC11); }))) {
            mixin(enumMixinStr___USE_ISOC11);
        }
    }




    static if(!is(typeof(INT_FAST16_MAX))) {
        private enum enumMixinStr_INT_FAST16_MAX = `enum INT_FAST16_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST16_MAX); }))) {
            mixin(enumMixinStr_INT_FAST16_MAX);
        }
    }




    static if(!is(typeof(INT_FAST32_MAX))) {
        private enum enumMixinStr_INT_FAST32_MAX = `enum INT_FAST32_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST32_MAX); }))) {
            mixin(enumMixinStr_INT_FAST32_MAX);
        }
    }




    static if(!is(typeof(INT_FAST64_MAX))) {
        private enum enumMixinStr_INT_FAST64_MAX = `enum INT_FAST64_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INT_FAST64_MAX); }))) {
            mixin(enumMixinStr_INT_FAST64_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST8_MAX))) {
        private enum enumMixinStr_UINT_FAST8_MAX = `enum UINT_FAST8_MAX = ( 255 );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST8_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST8_MAX);
        }
    }




    static if(!is(typeof(__GLIBC_USE_ISOC2X))) {
        private enum enumMixinStr___GLIBC_USE_ISOC2X = `enum __GLIBC_USE_ISOC2X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_ISOC2X); }))) {
            mixin(enumMixinStr___GLIBC_USE_ISOC2X);
        }
    }




    static if(!is(typeof(UINT_FAST16_MAX))) {
        private enum enumMixinStr_UINT_FAST16_MAX = `enum UINT_FAST16_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST16_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST16_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST32_MAX))) {
        private enum enumMixinStr_UINT_FAST32_MAX = `enum UINT_FAST32_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST32_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST32_MAX);
        }
    }




    static if(!is(typeof(UINT_FAST64_MAX))) {
        private enum enumMixinStr_UINT_FAST64_MAX = `enum UINT_FAST64_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINT_FAST64_MAX); }))) {
            mixin(enumMixinStr_UINT_FAST64_MAX);
        }
    }




    static if(!is(typeof(_DEFAULT_SOURCE))) {
        private enum enumMixinStr__DEFAULT_SOURCE = `enum _DEFAULT_SOURCE = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__DEFAULT_SOURCE); }))) {
            mixin(enumMixinStr__DEFAULT_SOURCE);
        }
    }




    static if(!is(typeof(INTPTR_MIN))) {
        private enum enumMixinStr_INTPTR_MIN = `enum INTPTR_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INTPTR_MIN); }))) {
            mixin(enumMixinStr_INTPTR_MIN);
        }
    }




    static if(!is(typeof(INTPTR_MAX))) {
        private enum enumMixinStr_INTPTR_MAX = `enum INTPTR_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INTPTR_MAX); }))) {
            mixin(enumMixinStr_INTPTR_MAX);
        }
    }




    static if(!is(typeof(UINTPTR_MAX))) {
        private enum enumMixinStr_UINTPTR_MAX = `enum UINTPTR_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINTPTR_MAX); }))) {
            mixin(enumMixinStr_UINTPTR_MAX);
        }
    }




    static if(!is(typeof(INTMAX_MIN))) {
        private enum enumMixinStr_INTMAX_MIN = `enum INTMAX_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_INTMAX_MIN); }))) {
            mixin(enumMixinStr_INTMAX_MIN);
        }
    }




    static if(!is(typeof(INTMAX_MAX))) {
        private enum enumMixinStr_INTMAX_MAX = `enum INTMAX_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_INTMAX_MAX); }))) {
            mixin(enumMixinStr_INTMAX_MAX);
        }
    }




    static if(!is(typeof(UINTMAX_MAX))) {
        private enum enumMixinStr_UINTMAX_MAX = `enum UINTMAX_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_UINTMAX_MAX); }))) {
            mixin(enumMixinStr_UINTMAX_MAX);
        }
    }






    static if(!is(typeof(PTRDIFF_MIN))) {
        private enum enumMixinStr_PTRDIFF_MIN = `enum PTRDIFF_MIN = ( - 9223372036854775807L - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_PTRDIFF_MIN); }))) {
            mixin(enumMixinStr_PTRDIFF_MIN);
        }
    }




    static if(!is(typeof(PTRDIFF_MAX))) {
        private enum enumMixinStr_PTRDIFF_MAX = `enum PTRDIFF_MAX = ( 9223372036854775807L );`;
        static if(is(typeof({ mixin(enumMixinStr_PTRDIFF_MAX); }))) {
            mixin(enumMixinStr_PTRDIFF_MAX);
        }
    }




    static if(!is(typeof(SIG_ATOMIC_MIN))) {
        private enum enumMixinStr_SIG_ATOMIC_MIN = `enum SIG_ATOMIC_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr_SIG_ATOMIC_MIN); }))) {
            mixin(enumMixinStr_SIG_ATOMIC_MIN);
        }
    }




    static if(!is(typeof(SIG_ATOMIC_MAX))) {
        private enum enumMixinStr_SIG_ATOMIC_MAX = `enum SIG_ATOMIC_MAX = ( 2147483647 );`;
        static if(is(typeof({ mixin(enumMixinStr_SIG_ATOMIC_MAX); }))) {
            mixin(enumMixinStr_SIG_ATOMIC_MAX);
        }
    }






    static if(!is(typeof(SIZE_MAX))) {
        private enum enumMixinStr_SIZE_MAX = `enum SIZE_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_SIZE_MAX); }))) {
            mixin(enumMixinStr_SIZE_MAX);
        }
    }




    static if(!is(typeof(WCHAR_MIN))) {
        private enum enumMixinStr_WCHAR_MIN = `enum WCHAR_MIN = __WCHAR_MIN;`;
        static if(is(typeof({ mixin(enumMixinStr_WCHAR_MIN); }))) {
            mixin(enumMixinStr_WCHAR_MIN);
        }
    }




    static if(!is(typeof(WCHAR_MAX))) {
        private enum enumMixinStr_WCHAR_MAX = `enum WCHAR_MAX = __WCHAR_MAX;`;
        static if(is(typeof({ mixin(enumMixinStr_WCHAR_MAX); }))) {
            mixin(enumMixinStr_WCHAR_MAX);
        }
    }




    static if(!is(typeof(WINT_MIN))) {
        private enum enumMixinStr_WINT_MIN = `enum WINT_MIN = ( 0u );`;
        static if(is(typeof({ mixin(enumMixinStr_WINT_MIN); }))) {
            mixin(enumMixinStr_WINT_MIN);
        }
    }




    static if(!is(typeof(WINT_MAX))) {
        private enum enumMixinStr_WINT_MAX = `enum WINT_MAX = ( 4294967295u );`;
        static if(is(typeof({ mixin(enumMixinStr_WINT_MAX); }))) {
            mixin(enumMixinStr_WINT_MAX);
        }
    }
    static if(!is(typeof(_FEATURES_H))) {
        private enum enumMixinStr__FEATURES_H = `enum _FEATURES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__FEATURES_H); }))) {
            mixin(enumMixinStr__FEATURES_H);
        }
    }
    static if(!is(typeof(_TIME_H))) {
        private enum enumMixinStr__TIME_H = `enum _TIME_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__TIME_H); }))) {
            mixin(enumMixinStr__TIME_H);
        }
    }




    static if(!is(typeof(NULL))) {
        private enum enumMixinStr_NULL = `enum NULL = ( cast( void * ) 0 );`;
        static if(is(typeof({ mixin(enumMixinStr_NULL); }))) {
            mixin(enumMixinStr_NULL);
        }
    }
    static if(!is(typeof(__bool_true_false_are_defined))) {
        private enum enumMixinStr___bool_true_false_are_defined = `enum __bool_true_false_are_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___bool_true_false_are_defined); }))) {
            mixin(enumMixinStr___bool_true_false_are_defined);
        }
    }




    static if(!is(typeof(false_))) {
        private enum enumMixinStr_false_ = `enum false_ = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_false_); }))) {
            mixin(enumMixinStr_false_);
        }
    }




    static if(!is(typeof(true_))) {
        private enum enumMixinStr_true_ = `enum true_ = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_true_); }))) {
            mixin(enumMixinStr_true_);
        }
    }




    static if(!is(typeof(bool_))) {
        private enum enumMixinStr_bool_ = `enum bool_ = _Bool;`;
        static if(is(typeof({ mixin(enumMixinStr_bool_); }))) {
            mixin(enumMixinStr_bool_);
        }
    }
    static if(!is(typeof(EMACS_LIMB_MAX))) {
        private enum enumMixinStr_EMACS_LIMB_MAX = `enum EMACS_LIMB_MAX = ( 18446744073709551615UL );`;
        static if(is(typeof({ mixin(enumMixinStr_EMACS_LIMB_MAX); }))) {
            mixin(enumMixinStr_EMACS_LIMB_MAX);
        }
    }






    static if(!is(typeof(TIME_UTC))) {
        private enum enumMixinStr_TIME_UTC = `enum TIME_UTC = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_TIME_UTC); }))) {
            mixin(enumMixinStr_TIME_UTC);
        }
    }






    static if(!is(typeof(EMACS_MAJOR_VERSION))) {
        private enum enumMixinStr_EMACS_MAJOR_VERSION = `enum EMACS_MAJOR_VERSION = 27;`;
        static if(is(typeof({ mixin(enumMixinStr_EMACS_MAJOR_VERSION); }))) {
            mixin(enumMixinStr_EMACS_MAJOR_VERSION);
        }
    }
    static if(!is(typeof(_BITS_ENDIAN_H))) {
        private enum enumMixinStr__BITS_ENDIAN_H = `enum _BITS_ENDIAN_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_ENDIAN_H); }))) {
            mixin(enumMixinStr__BITS_ENDIAN_H);
        }
    }




    static if(!is(typeof(__LITTLE_ENDIAN))) {
        private enum enumMixinStr___LITTLE_ENDIAN = `enum __LITTLE_ENDIAN = 1234;`;
        static if(is(typeof({ mixin(enumMixinStr___LITTLE_ENDIAN); }))) {
            mixin(enumMixinStr___LITTLE_ENDIAN);
        }
    }




    static if(!is(typeof(__BIG_ENDIAN))) {
        private enum enumMixinStr___BIG_ENDIAN = `enum __BIG_ENDIAN = 4321;`;
        static if(is(typeof({ mixin(enumMixinStr___BIG_ENDIAN); }))) {
            mixin(enumMixinStr___BIG_ENDIAN);
        }
    }




    static if(!is(typeof(__PDP_ENDIAN))) {
        private enum enumMixinStr___PDP_ENDIAN = `enum __PDP_ENDIAN = 3412;`;
        static if(is(typeof({ mixin(enumMixinStr___PDP_ENDIAN); }))) {
            mixin(enumMixinStr___PDP_ENDIAN);
        }
    }




    static if(!is(typeof(__FLOAT_WORD_ORDER))) {
        private enum enumMixinStr___FLOAT_WORD_ORDER = `enum __FLOAT_WORD_ORDER = __BYTE_ORDER;`;
        static if(is(typeof({ mixin(enumMixinStr___FLOAT_WORD_ORDER); }))) {
            mixin(enumMixinStr___FLOAT_WORD_ORDER);
        }
    }






    static if(!is(typeof(_BITS_ENDIANNESS_H))) {
        private enum enumMixinStr__BITS_ENDIANNESS_H = `enum _BITS_ENDIANNESS_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_ENDIANNESS_H); }))) {
            mixin(enumMixinStr__BITS_ENDIANNESS_H);
        }
    }




    static if(!is(typeof(__BYTE_ORDER))) {
        private enum enumMixinStr___BYTE_ORDER = `enum __BYTE_ORDER = 1234;`;
        static if(is(typeof({ mixin(enumMixinStr___BYTE_ORDER); }))) {
            mixin(enumMixinStr___BYTE_ORDER);
        }
    }




    static if(!is(typeof(__GLIBC_USE_LIB_EXT2))) {
        private enum enumMixinStr___GLIBC_USE_LIB_EXT2 = `enum __GLIBC_USE_LIB_EXT2 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_LIB_EXT2); }))) {
            mixin(enumMixinStr___GLIBC_USE_LIB_EXT2);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_BFP_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT = `enum __GLIBC_USE_IEC_60559_BFP_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_BFP_EXT_C2X))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT_C2X = `enum __GLIBC_USE_IEC_60559_BFP_EXT_C2X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT_C2X); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_BFP_EXT_C2X);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT = `enum __GLIBC_USE_IEC_60559_FUNCS_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_FUNCS_EXT_C2X))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = `enum __GLIBC_USE_IEC_60559_FUNCS_EXT_C2X = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT_C2X); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_FUNCS_EXT_C2X);
        }
    }




    static if(!is(typeof(__GLIBC_USE_IEC_60559_TYPES_EXT))) {
        private enum enumMixinStr___GLIBC_USE_IEC_60559_TYPES_EXT = `enum __GLIBC_USE_IEC_60559_TYPES_EXT = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___GLIBC_USE_IEC_60559_TYPES_EXT); }))) {
            mixin(enumMixinStr___GLIBC_USE_IEC_60559_TYPES_EXT);
        }
    }




    static if(!is(typeof(__LONG_DOUBLE_USES_FLOAT128))) {
        private enum enumMixinStr___LONG_DOUBLE_USES_FLOAT128 = `enum __LONG_DOUBLE_USES_FLOAT128 = 0;`;
        static if(is(typeof({ mixin(enumMixinStr___LONG_DOUBLE_USES_FLOAT128); }))) {
            mixin(enumMixinStr___LONG_DOUBLE_USES_FLOAT128);
        }
    }




    static if(!is(typeof(_BITS_STDINT_INTN_H))) {
        private enum enumMixinStr__BITS_STDINT_INTN_H = `enum _BITS_STDINT_INTN_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_STDINT_INTN_H); }))) {
            mixin(enumMixinStr__BITS_STDINT_INTN_H);
        }
    }




    static if(!is(typeof(_BITS_STDINT_UINTN_H))) {
        private enum enumMixinStr__BITS_STDINT_UINTN_H = `enum _BITS_STDINT_UINTN_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_STDINT_UINTN_H); }))) {
            mixin(enumMixinStr__BITS_STDINT_UINTN_H);
        }
    }




    static if(!is(typeof(_BITS_TIME_H))) {
        private enum enumMixinStr__BITS_TIME_H = `enum _BITS_TIME_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TIME_H); }))) {
            mixin(enumMixinStr__BITS_TIME_H);
        }
    }




    static if(!is(typeof(CLOCKS_PER_SEC))) {
        private enum enumMixinStr_CLOCKS_PER_SEC = `enum CLOCKS_PER_SEC = ( cast( __clock_t ) 1000000 );`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCKS_PER_SEC); }))) {
            mixin(enumMixinStr_CLOCKS_PER_SEC);
        }
    }




    static if(!is(typeof(CLOCK_REALTIME))) {
        private enum enumMixinStr_CLOCK_REALTIME = `enum CLOCK_REALTIME = 0;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_REALTIME); }))) {
            mixin(enumMixinStr_CLOCK_REALTIME);
        }
    }




    static if(!is(typeof(CLOCK_MONOTONIC))) {
        private enum enumMixinStr_CLOCK_MONOTONIC = `enum CLOCK_MONOTONIC = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_MONOTONIC); }))) {
            mixin(enumMixinStr_CLOCK_MONOTONIC);
        }
    }




    static if(!is(typeof(CLOCK_PROCESS_CPUTIME_ID))) {
        private enum enumMixinStr_CLOCK_PROCESS_CPUTIME_ID = `enum CLOCK_PROCESS_CPUTIME_ID = 2;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_PROCESS_CPUTIME_ID); }))) {
            mixin(enumMixinStr_CLOCK_PROCESS_CPUTIME_ID);
        }
    }




    static if(!is(typeof(CLOCK_THREAD_CPUTIME_ID))) {
        private enum enumMixinStr_CLOCK_THREAD_CPUTIME_ID = `enum CLOCK_THREAD_CPUTIME_ID = 3;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_THREAD_CPUTIME_ID); }))) {
            mixin(enumMixinStr_CLOCK_THREAD_CPUTIME_ID);
        }
    }




    static if(!is(typeof(CLOCK_MONOTONIC_RAW))) {
        private enum enumMixinStr_CLOCK_MONOTONIC_RAW = `enum CLOCK_MONOTONIC_RAW = 4;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_MONOTONIC_RAW); }))) {
            mixin(enumMixinStr_CLOCK_MONOTONIC_RAW);
        }
    }




    static if(!is(typeof(CLOCK_REALTIME_COARSE))) {
        private enum enumMixinStr_CLOCK_REALTIME_COARSE = `enum CLOCK_REALTIME_COARSE = 5;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_REALTIME_COARSE); }))) {
            mixin(enumMixinStr_CLOCK_REALTIME_COARSE);
        }
    }




    static if(!is(typeof(CLOCK_MONOTONIC_COARSE))) {
        private enum enumMixinStr_CLOCK_MONOTONIC_COARSE = `enum CLOCK_MONOTONIC_COARSE = 6;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_MONOTONIC_COARSE); }))) {
            mixin(enumMixinStr_CLOCK_MONOTONIC_COARSE);
        }
    }




    static if(!is(typeof(CLOCK_BOOTTIME))) {
        private enum enumMixinStr_CLOCK_BOOTTIME = `enum CLOCK_BOOTTIME = 7;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_BOOTTIME); }))) {
            mixin(enumMixinStr_CLOCK_BOOTTIME);
        }
    }




    static if(!is(typeof(CLOCK_REALTIME_ALARM))) {
        private enum enumMixinStr_CLOCK_REALTIME_ALARM = `enum CLOCK_REALTIME_ALARM = 8;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_REALTIME_ALARM); }))) {
            mixin(enumMixinStr_CLOCK_REALTIME_ALARM);
        }
    }




    static if(!is(typeof(CLOCK_BOOTTIME_ALARM))) {
        private enum enumMixinStr_CLOCK_BOOTTIME_ALARM = `enum CLOCK_BOOTTIME_ALARM = 9;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_BOOTTIME_ALARM); }))) {
            mixin(enumMixinStr_CLOCK_BOOTTIME_ALARM);
        }
    }




    static if(!is(typeof(CLOCK_TAI))) {
        private enum enumMixinStr_CLOCK_TAI = `enum CLOCK_TAI = 11;`;
        static if(is(typeof({ mixin(enumMixinStr_CLOCK_TAI); }))) {
            mixin(enumMixinStr_CLOCK_TAI);
        }
    }




    static if(!is(typeof(TIMER_ABSTIME))) {
        private enum enumMixinStr_TIMER_ABSTIME = `enum TIMER_ABSTIME = 1;`;
        static if(is(typeof({ mixin(enumMixinStr_TIMER_ABSTIME); }))) {
            mixin(enumMixinStr_TIMER_ABSTIME);
        }
    }




    static if(!is(typeof(_BITS_TIME64_H))) {
        private enum enumMixinStr__BITS_TIME64_H = `enum _BITS_TIME64_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TIME64_H); }))) {
            mixin(enumMixinStr__BITS_TIME64_H);
        }
    }




    static if(!is(typeof(__TIME64_T_TYPE))) {
        private enum enumMixinStr___TIME64_T_TYPE = `enum __TIME64_T_TYPE = __TIME_T_TYPE;`;
        static if(is(typeof({ mixin(enumMixinStr___TIME64_T_TYPE); }))) {
            mixin(enumMixinStr___TIME64_T_TYPE);
        }
    }




    static if(!is(typeof(__TIMESIZE))) {
        private enum enumMixinStr___TIMESIZE = `enum __TIMESIZE = __WORDSIZE;`;
        static if(is(typeof({ mixin(enumMixinStr___TIMESIZE); }))) {
            mixin(enumMixinStr___TIMESIZE);
        }
    }




    static if(!is(typeof(_BITS_TYPES_H))) {
        private enum enumMixinStr__BITS_TYPES_H = `enum _BITS_TYPES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TYPES_H); }))) {
            mixin(enumMixinStr__BITS_TYPES_H);
        }
    }




    static if(!is(typeof(__S16_TYPE))) {
        private enum enumMixinStr___S16_TYPE = `enum __S16_TYPE = short int;`;
        static if(is(typeof({ mixin(enumMixinStr___S16_TYPE); }))) {
            mixin(enumMixinStr___S16_TYPE);
        }
    }




    static if(!is(typeof(__U16_TYPE))) {
        private enum enumMixinStr___U16_TYPE = `enum __U16_TYPE = unsigned short int;`;
        static if(is(typeof({ mixin(enumMixinStr___U16_TYPE); }))) {
            mixin(enumMixinStr___U16_TYPE);
        }
    }




    static if(!is(typeof(__S32_TYPE))) {
        private enum enumMixinStr___S32_TYPE = `enum __S32_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___S32_TYPE); }))) {
            mixin(enumMixinStr___S32_TYPE);
        }
    }




    static if(!is(typeof(__U32_TYPE))) {
        private enum enumMixinStr___U32_TYPE = `enum __U32_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___U32_TYPE); }))) {
            mixin(enumMixinStr___U32_TYPE);
        }
    }




    static if(!is(typeof(__SLONGWORD_TYPE))) {
        private enum enumMixinStr___SLONGWORD_TYPE = `enum __SLONGWORD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SLONGWORD_TYPE); }))) {
            mixin(enumMixinStr___SLONGWORD_TYPE);
        }
    }




    static if(!is(typeof(__ULONGWORD_TYPE))) {
        private enum enumMixinStr___ULONGWORD_TYPE = `enum __ULONGWORD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___ULONGWORD_TYPE); }))) {
            mixin(enumMixinStr___ULONGWORD_TYPE);
        }
    }




    static if(!is(typeof(__SQUAD_TYPE))) {
        private enum enumMixinStr___SQUAD_TYPE = `enum __SQUAD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SQUAD_TYPE); }))) {
            mixin(enumMixinStr___SQUAD_TYPE);
        }
    }




    static if(!is(typeof(__UQUAD_TYPE))) {
        private enum enumMixinStr___UQUAD_TYPE = `enum __UQUAD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___UQUAD_TYPE); }))) {
            mixin(enumMixinStr___UQUAD_TYPE);
        }
    }




    static if(!is(typeof(__SWORD_TYPE))) {
        private enum enumMixinStr___SWORD_TYPE = `enum __SWORD_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SWORD_TYPE); }))) {
            mixin(enumMixinStr___SWORD_TYPE);
        }
    }




    static if(!is(typeof(__UWORD_TYPE))) {
        private enum enumMixinStr___UWORD_TYPE = `enum __UWORD_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___UWORD_TYPE); }))) {
            mixin(enumMixinStr___UWORD_TYPE);
        }
    }




    static if(!is(typeof(__SLONG32_TYPE))) {
        private enum enumMixinStr___SLONG32_TYPE = `enum __SLONG32_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___SLONG32_TYPE); }))) {
            mixin(enumMixinStr___SLONG32_TYPE);
        }
    }




    static if(!is(typeof(__ULONG32_TYPE))) {
        private enum enumMixinStr___ULONG32_TYPE = `enum __ULONG32_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___ULONG32_TYPE); }))) {
            mixin(enumMixinStr___ULONG32_TYPE);
        }
    }




    static if(!is(typeof(__S64_TYPE))) {
        private enum enumMixinStr___S64_TYPE = `enum __S64_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___S64_TYPE); }))) {
            mixin(enumMixinStr___S64_TYPE);
        }
    }




    static if(!is(typeof(__U64_TYPE))) {
        private enum enumMixinStr___U64_TYPE = `enum __U64_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___U64_TYPE); }))) {
            mixin(enumMixinStr___U64_TYPE);
        }
    }




    static if(!is(typeof(__STD_TYPE))) {
        private enum enumMixinStr___STD_TYPE = `enum __STD_TYPE = typedef;`;
        static if(is(typeof({ mixin(enumMixinStr___STD_TYPE); }))) {
            mixin(enumMixinStr___STD_TYPE);
        }
    }




    static if(!is(typeof(_BITS_TYPES___LOCALE_T_H))) {
        private enum enumMixinStr__BITS_TYPES___LOCALE_T_H = `enum _BITS_TYPES___LOCALE_T_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TYPES___LOCALE_T_H); }))) {
            mixin(enumMixinStr__BITS_TYPES___LOCALE_T_H);
        }
    }




    static if(!is(typeof(__clock_t_defined))) {
        private enum enumMixinStr___clock_t_defined = `enum __clock_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___clock_t_defined); }))) {
            mixin(enumMixinStr___clock_t_defined);
        }
    }




    static if(!is(typeof(__clockid_t_defined))) {
        private enum enumMixinStr___clockid_t_defined = `enum __clockid_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___clockid_t_defined); }))) {
            mixin(enumMixinStr___clockid_t_defined);
        }
    }




    static if(!is(typeof(_BITS_TYPES_LOCALE_T_H))) {
        private enum enumMixinStr__BITS_TYPES_LOCALE_T_H = `enum _BITS_TYPES_LOCALE_T_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TYPES_LOCALE_T_H); }))) {
            mixin(enumMixinStr__BITS_TYPES_LOCALE_T_H);
        }
    }




    static if(!is(typeof(__itimerspec_defined))) {
        private enum enumMixinStr___itimerspec_defined = `enum __itimerspec_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___itimerspec_defined); }))) {
            mixin(enumMixinStr___itimerspec_defined);
        }
    }




    static if(!is(typeof(_STRUCT_TIMESPEC))) {
        private enum enumMixinStr__STRUCT_TIMESPEC = `enum _STRUCT_TIMESPEC = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__STRUCT_TIMESPEC); }))) {
            mixin(enumMixinStr__STRUCT_TIMESPEC);
        }
    }




    static if(!is(typeof(__struct_tm_defined))) {
        private enum enumMixinStr___struct_tm_defined = `enum __struct_tm_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___struct_tm_defined); }))) {
            mixin(enumMixinStr___struct_tm_defined);
        }
    }




    static if(!is(typeof(__time_t_defined))) {
        private enum enumMixinStr___time_t_defined = `enum __time_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___time_t_defined); }))) {
            mixin(enumMixinStr___time_t_defined);
        }
    }




    static if(!is(typeof(__timer_t_defined))) {
        private enum enumMixinStr___timer_t_defined = `enum __timer_t_defined = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___timer_t_defined); }))) {
            mixin(enumMixinStr___timer_t_defined);
        }
    }




    static if(!is(typeof(_BITS_TYPESIZES_H))) {
        private enum enumMixinStr__BITS_TYPESIZES_H = `enum _BITS_TYPESIZES_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_TYPESIZES_H); }))) {
            mixin(enumMixinStr__BITS_TYPESIZES_H);
        }
    }




    static if(!is(typeof(__SYSCALL_SLONG_TYPE))) {
        private enum enumMixinStr___SYSCALL_SLONG_TYPE = `enum __SYSCALL_SLONG_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_SLONG_TYPE); }))) {
            mixin(enumMixinStr___SYSCALL_SLONG_TYPE);
        }
    }




    static if(!is(typeof(__SYSCALL_ULONG_TYPE))) {
        private enum enumMixinStr___SYSCALL_ULONG_TYPE = `enum __SYSCALL_ULONG_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_ULONG_TYPE); }))) {
            mixin(enumMixinStr___SYSCALL_ULONG_TYPE);
        }
    }




    static if(!is(typeof(__DEV_T_TYPE))) {
        private enum enumMixinStr___DEV_T_TYPE = `enum __DEV_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___DEV_T_TYPE); }))) {
            mixin(enumMixinStr___DEV_T_TYPE);
        }
    }




    static if(!is(typeof(__UID_T_TYPE))) {
        private enum enumMixinStr___UID_T_TYPE = `enum __UID_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___UID_T_TYPE); }))) {
            mixin(enumMixinStr___UID_T_TYPE);
        }
    }




    static if(!is(typeof(__GID_T_TYPE))) {
        private enum enumMixinStr___GID_T_TYPE = `enum __GID_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___GID_T_TYPE); }))) {
            mixin(enumMixinStr___GID_T_TYPE);
        }
    }




    static if(!is(typeof(__INO_T_TYPE))) {
        private enum enumMixinStr___INO_T_TYPE = `enum __INO_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___INO_T_TYPE); }))) {
            mixin(enumMixinStr___INO_T_TYPE);
        }
    }




    static if(!is(typeof(__INO64_T_TYPE))) {
        private enum enumMixinStr___INO64_T_TYPE = `enum __INO64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___INO64_T_TYPE); }))) {
            mixin(enumMixinStr___INO64_T_TYPE);
        }
    }




    static if(!is(typeof(__MODE_T_TYPE))) {
        private enum enumMixinStr___MODE_T_TYPE = `enum __MODE_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___MODE_T_TYPE); }))) {
            mixin(enumMixinStr___MODE_T_TYPE);
        }
    }




    static if(!is(typeof(__NLINK_T_TYPE))) {
        private enum enumMixinStr___NLINK_T_TYPE = `enum __NLINK_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___NLINK_T_TYPE); }))) {
            mixin(enumMixinStr___NLINK_T_TYPE);
        }
    }




    static if(!is(typeof(__FSWORD_T_TYPE))) {
        private enum enumMixinStr___FSWORD_T_TYPE = `enum __FSWORD_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSWORD_T_TYPE); }))) {
            mixin(enumMixinStr___FSWORD_T_TYPE);
        }
    }




    static if(!is(typeof(__OFF_T_TYPE))) {
        private enum enumMixinStr___OFF_T_TYPE = `enum __OFF_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF_T_TYPE); }))) {
            mixin(enumMixinStr___OFF_T_TYPE);
        }
    }




    static if(!is(typeof(__OFF64_T_TYPE))) {
        private enum enumMixinStr___OFF64_T_TYPE = `enum __OFF64_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF64_T_TYPE); }))) {
            mixin(enumMixinStr___OFF64_T_TYPE);
        }
    }




    static if(!is(typeof(__PID_T_TYPE))) {
        private enum enumMixinStr___PID_T_TYPE = `enum __PID_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___PID_T_TYPE); }))) {
            mixin(enumMixinStr___PID_T_TYPE);
        }
    }




    static if(!is(typeof(__RLIM_T_TYPE))) {
        private enum enumMixinStr___RLIM_T_TYPE = `enum __RLIM_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM_T_TYPE); }))) {
            mixin(enumMixinStr___RLIM_T_TYPE);
        }
    }




    static if(!is(typeof(__RLIM64_T_TYPE))) {
        private enum enumMixinStr___RLIM64_T_TYPE = `enum __RLIM64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM64_T_TYPE); }))) {
            mixin(enumMixinStr___RLIM64_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKCNT_T_TYPE))) {
        private enum enumMixinStr___BLKCNT_T_TYPE = `enum __BLKCNT_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKCNT_T_TYPE); }))) {
            mixin(enumMixinStr___BLKCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKCNT64_T_TYPE))) {
        private enum enumMixinStr___BLKCNT64_T_TYPE = `enum __BLKCNT64_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___BLKCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__FSBLKCNT_T_TYPE))) {
        private enum enumMixinStr___FSBLKCNT_T_TYPE = `enum __FSBLKCNT_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSBLKCNT_T_TYPE); }))) {
            mixin(enumMixinStr___FSBLKCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__FSBLKCNT64_T_TYPE))) {
        private enum enumMixinStr___FSBLKCNT64_T_TYPE = `enum __FSBLKCNT64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSBLKCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___FSBLKCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__FSFILCNT_T_TYPE))) {
        private enum enumMixinStr___FSFILCNT_T_TYPE = `enum __FSFILCNT_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSFILCNT_T_TYPE); }))) {
            mixin(enumMixinStr___FSFILCNT_T_TYPE);
        }
    }




    static if(!is(typeof(__FSFILCNT64_T_TYPE))) {
        private enum enumMixinStr___FSFILCNT64_T_TYPE = `enum __FSFILCNT64_T_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___FSFILCNT64_T_TYPE); }))) {
            mixin(enumMixinStr___FSFILCNT64_T_TYPE);
        }
    }




    static if(!is(typeof(__ID_T_TYPE))) {
        private enum enumMixinStr___ID_T_TYPE = `enum __ID_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___ID_T_TYPE); }))) {
            mixin(enumMixinStr___ID_T_TYPE);
        }
    }




    static if(!is(typeof(__CLOCK_T_TYPE))) {
        private enum enumMixinStr___CLOCK_T_TYPE = `enum __CLOCK_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___CLOCK_T_TYPE); }))) {
            mixin(enumMixinStr___CLOCK_T_TYPE);
        }
    }




    static if(!is(typeof(__TIME_T_TYPE))) {
        private enum enumMixinStr___TIME_T_TYPE = `enum __TIME_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___TIME_T_TYPE); }))) {
            mixin(enumMixinStr___TIME_T_TYPE);
        }
    }




    static if(!is(typeof(__USECONDS_T_TYPE))) {
        private enum enumMixinStr___USECONDS_T_TYPE = `enum __USECONDS_T_TYPE = unsigned int;`;
        static if(is(typeof({ mixin(enumMixinStr___USECONDS_T_TYPE); }))) {
            mixin(enumMixinStr___USECONDS_T_TYPE);
        }
    }




    static if(!is(typeof(__SUSECONDS_T_TYPE))) {
        private enum enumMixinStr___SUSECONDS_T_TYPE = `enum __SUSECONDS_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SUSECONDS_T_TYPE); }))) {
            mixin(enumMixinStr___SUSECONDS_T_TYPE);
        }
    }




    static if(!is(typeof(__DADDR_T_TYPE))) {
        private enum enumMixinStr___DADDR_T_TYPE = `enum __DADDR_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___DADDR_T_TYPE); }))) {
            mixin(enumMixinStr___DADDR_T_TYPE);
        }
    }




    static if(!is(typeof(__KEY_T_TYPE))) {
        private enum enumMixinStr___KEY_T_TYPE = `enum __KEY_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___KEY_T_TYPE); }))) {
            mixin(enumMixinStr___KEY_T_TYPE);
        }
    }




    static if(!is(typeof(__CLOCKID_T_TYPE))) {
        private enum enumMixinStr___CLOCKID_T_TYPE = `enum __CLOCKID_T_TYPE = int;`;
        static if(is(typeof({ mixin(enumMixinStr___CLOCKID_T_TYPE); }))) {
            mixin(enumMixinStr___CLOCKID_T_TYPE);
        }
    }




    static if(!is(typeof(__TIMER_T_TYPE))) {
        private enum enumMixinStr___TIMER_T_TYPE = `enum __TIMER_T_TYPE = void *;`;
        static if(is(typeof({ mixin(enumMixinStr___TIMER_T_TYPE); }))) {
            mixin(enumMixinStr___TIMER_T_TYPE);
        }
    }




    static if(!is(typeof(__BLKSIZE_T_TYPE))) {
        private enum enumMixinStr___BLKSIZE_T_TYPE = `enum __BLKSIZE_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___BLKSIZE_T_TYPE); }))) {
            mixin(enumMixinStr___BLKSIZE_T_TYPE);
        }
    }




    static if(!is(typeof(__FSID_T_TYPE))) {
        private enum enumMixinStr___FSID_T_TYPE = `enum __FSID_T_TYPE = { int __val [ 2 ] ; };`;
        static if(is(typeof({ mixin(enumMixinStr___FSID_T_TYPE); }))) {
            mixin(enumMixinStr___FSID_T_TYPE);
        }
    }




    static if(!is(typeof(__SSIZE_T_TYPE))) {
        private enum enumMixinStr___SSIZE_T_TYPE = `enum __SSIZE_T_TYPE = long int;`;
        static if(is(typeof({ mixin(enumMixinStr___SSIZE_T_TYPE); }))) {
            mixin(enumMixinStr___SSIZE_T_TYPE);
        }
    }




    static if(!is(typeof(__CPU_MASK_TYPE))) {
        private enum enumMixinStr___CPU_MASK_TYPE = `enum __CPU_MASK_TYPE = unsigned long int;`;
        static if(is(typeof({ mixin(enumMixinStr___CPU_MASK_TYPE); }))) {
            mixin(enumMixinStr___CPU_MASK_TYPE);
        }
    }




    static if(!is(typeof(__OFF_T_MATCHES_OFF64_T))) {
        private enum enumMixinStr___OFF_T_MATCHES_OFF64_T = `enum __OFF_T_MATCHES_OFF64_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___OFF_T_MATCHES_OFF64_T); }))) {
            mixin(enumMixinStr___OFF_T_MATCHES_OFF64_T);
        }
    }




    static if(!is(typeof(__INO_T_MATCHES_INO64_T))) {
        private enum enumMixinStr___INO_T_MATCHES_INO64_T = `enum __INO_T_MATCHES_INO64_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___INO_T_MATCHES_INO64_T); }))) {
            mixin(enumMixinStr___INO_T_MATCHES_INO64_T);
        }
    }




    static if(!is(typeof(__RLIM_T_MATCHES_RLIM64_T))) {
        private enum enumMixinStr___RLIM_T_MATCHES_RLIM64_T = `enum __RLIM_T_MATCHES_RLIM64_T = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___RLIM_T_MATCHES_RLIM64_T); }))) {
            mixin(enumMixinStr___RLIM_T_MATCHES_RLIM64_T);
        }
    }




    static if(!is(typeof(__STATFS_MATCHES_STATFS64))) {
        private enum enumMixinStr___STATFS_MATCHES_STATFS64 = `enum __STATFS_MATCHES_STATFS64 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___STATFS_MATCHES_STATFS64); }))) {
            mixin(enumMixinStr___STATFS_MATCHES_STATFS64);
        }
    }




    static if(!is(typeof(__FD_SETSIZE))) {
        private enum enumMixinStr___FD_SETSIZE = `enum __FD_SETSIZE = 1024;`;
        static if(is(typeof({ mixin(enumMixinStr___FD_SETSIZE); }))) {
            mixin(enumMixinStr___FD_SETSIZE);
        }
    }




    static if(!is(typeof(_BITS_WCHAR_H))) {
        private enum enumMixinStr__BITS_WCHAR_H = `enum _BITS_WCHAR_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__BITS_WCHAR_H); }))) {
            mixin(enumMixinStr__BITS_WCHAR_H);
        }
    }




    static if(!is(typeof(__WCHAR_MAX))) {
        private enum enumMixinStr___WCHAR_MAX = `enum __WCHAR_MAX = 2147483647;`;
        static if(is(typeof({ mixin(enumMixinStr___WCHAR_MAX); }))) {
            mixin(enumMixinStr___WCHAR_MAX);
        }
    }




    static if(!is(typeof(__WCHAR_MIN))) {
        private enum enumMixinStr___WCHAR_MIN = `enum __WCHAR_MIN = ( - 2147483647 - 1 );`;
        static if(is(typeof({ mixin(enumMixinStr___WCHAR_MIN); }))) {
            mixin(enumMixinStr___WCHAR_MIN);
        }
    }




    static if(!is(typeof(__WORDSIZE))) {
        private enum enumMixinStr___WORDSIZE = `enum __WORDSIZE = 64;`;
        static if(is(typeof({ mixin(enumMixinStr___WORDSIZE); }))) {
            mixin(enumMixinStr___WORDSIZE);
        }
    }




    static if(!is(typeof(__WORDSIZE_TIME64_COMPAT32))) {
        private enum enumMixinStr___WORDSIZE_TIME64_COMPAT32 = `enum __WORDSIZE_TIME64_COMPAT32 = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___WORDSIZE_TIME64_COMPAT32); }))) {
            mixin(enumMixinStr___WORDSIZE_TIME64_COMPAT32);
        }
    }




    static if(!is(typeof(__SYSCALL_WORDSIZE))) {
        private enum enumMixinStr___SYSCALL_WORDSIZE = `enum __SYSCALL_WORDSIZE = 64;`;
        static if(is(typeof({ mixin(enumMixinStr___SYSCALL_WORDSIZE); }))) {
            mixin(enumMixinStr___SYSCALL_WORDSIZE);
        }
    }
    static if(!is(typeof(_SYS_CDEFS_H))) {
        private enum enumMixinStr__SYS_CDEFS_H = `enum _SYS_CDEFS_H = 1;`;
        static if(is(typeof({ mixin(enumMixinStr__SYS_CDEFS_H); }))) {
            mixin(enumMixinStr__SYS_CDEFS_H);
        }
    }
    static if(!is(typeof(__THROW))) {
        private enum enumMixinStr___THROW = `enum __THROW = __attribute__ ( ( __nothrow__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___THROW); }))) {
            mixin(enumMixinStr___THROW);
        }
    }




    static if(!is(typeof(__THROWNL))) {
        private enum enumMixinStr___THROWNL = `enum __THROWNL = __attribute__ ( ( __nothrow__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___THROWNL); }))) {
            mixin(enumMixinStr___THROWNL);
        }
    }
    static if(!is(typeof(__ptr_t))) {
        private enum enumMixinStr___ptr_t = `enum __ptr_t = void *;`;
        static if(is(typeof({ mixin(enumMixinStr___ptr_t); }))) {
            mixin(enumMixinStr___ptr_t);
        }
    }
    static if(!is(typeof(__flexarr))) {
        private enum enumMixinStr___flexarr = `enum __flexarr = [ ];`;
        static if(is(typeof({ mixin(enumMixinStr___flexarr); }))) {
            mixin(enumMixinStr___flexarr);
        }
    }




    static if(!is(typeof(__glibc_c99_flexarr_available))) {
        private enum enumMixinStr___glibc_c99_flexarr_available = `enum __glibc_c99_flexarr_available = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___glibc_c99_flexarr_available); }))) {
            mixin(enumMixinStr___glibc_c99_flexarr_available);
        }
    }
    static if(!is(typeof(__attribute_malloc__))) {
        private enum enumMixinStr___attribute_malloc__ = `enum __attribute_malloc__ = __attribute__ ( ( __malloc__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_malloc__); }))) {
            mixin(enumMixinStr___attribute_malloc__);
        }
    }






    static if(!is(typeof(__attribute_pure__))) {
        private enum enumMixinStr___attribute_pure__ = `enum __attribute_pure__ = __attribute__ ( ( __pure__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_pure__); }))) {
            mixin(enumMixinStr___attribute_pure__);
        }
    }




    static if(!is(typeof(__attribute_const__))) {
        private enum enumMixinStr___attribute_const__ = `enum __attribute_const__ = __attribute__ ( cast( __const__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_const__); }))) {
            mixin(enumMixinStr___attribute_const__);
        }
    }




    static if(!is(typeof(__attribute_used__))) {
        private enum enumMixinStr___attribute_used__ = `enum __attribute_used__ = __attribute__ ( ( __used__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_used__); }))) {
            mixin(enumMixinStr___attribute_used__);
        }
    }




    static if(!is(typeof(__attribute_noinline__))) {
        private enum enumMixinStr___attribute_noinline__ = `enum __attribute_noinline__ = __attribute__ ( ( __noinline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_noinline__); }))) {
            mixin(enumMixinStr___attribute_noinline__);
        }
    }




    static if(!is(typeof(__attribute_deprecated__))) {
        private enum enumMixinStr___attribute_deprecated__ = `enum __attribute_deprecated__ = __attribute__ ( ( __deprecated__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_deprecated__); }))) {
            mixin(enumMixinStr___attribute_deprecated__);
        }
    }
    static if(!is(typeof(__attribute_warn_unused_result__))) {
        private enum enumMixinStr___attribute_warn_unused_result__ = `enum __attribute_warn_unused_result__ = __attribute__ ( ( __warn_unused_result__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___attribute_warn_unused_result__); }))) {
            mixin(enumMixinStr___attribute_warn_unused_result__);
        }
    }






    static if(!is(typeof(__always_inline))) {
        private enum enumMixinStr___always_inline = `enum __always_inline = __inline __attribute__ ( ( __always_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___always_inline); }))) {
            mixin(enumMixinStr___always_inline);
        }
    }






    static if(!is(typeof(__extern_inline))) {
        private enum enumMixinStr___extern_inline = `enum __extern_inline = extern __inline __attribute__ ( ( __gnu_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___extern_inline); }))) {
            mixin(enumMixinStr___extern_inline);
        }
    }




    static if(!is(typeof(__extern_always_inline))) {
        private enum enumMixinStr___extern_always_inline = `enum __extern_always_inline = extern __inline __attribute__ ( ( __always_inline__ ) ) __attribute__ ( ( __gnu_inline__ ) );`;
        static if(is(typeof({ mixin(enumMixinStr___extern_always_inline); }))) {
            mixin(enumMixinStr___extern_always_inline);
        }
    }




    static if(!is(typeof(__fortify_function))) {
        private enum enumMixinStr___fortify_function = `enum __fortify_function = extern __inline __attribute__ ( ( __always_inline__ ) ) __attribute__ ( ( __gnu_inline__ ) ) ;`;
        static if(is(typeof({ mixin(enumMixinStr___fortify_function); }))) {
            mixin(enumMixinStr___fortify_function);
        }
    }




    static if(!is(typeof(__restrict_arr))) {
        private enum enumMixinStr___restrict_arr = `enum __restrict_arr = __restrict;`;
        static if(is(typeof({ mixin(enumMixinStr___restrict_arr); }))) {
            mixin(enumMixinStr___restrict_arr);
        }
    }
    static if(!is(typeof(__HAVE_GENERIC_SELECTION))) {
        private enum enumMixinStr___HAVE_GENERIC_SELECTION = `enum __HAVE_GENERIC_SELECTION = 1;`;
        static if(is(typeof({ mixin(enumMixinStr___HAVE_GENERIC_SELECTION); }))) {
            mixin(enumMixinStr___HAVE_GENERIC_SELECTION);
        }
    }

}


struct emacs_env_private;
struct emacs_runtime_private;
