; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -slp-vectorizer -dce -S -mtriple=x86_64-apple-macosx10.8.0 -mcpu=corei7-avx | FileCheck %s

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

; int foo(double *A, float *B, int g) {
;   float B0 = B[0];
;   float B1 = B[1]; <----- BasicBlock #1
;   B0 += 5;
;   B1 += 8;
;
;   if (g) bar();
;
;   A[0] += B0;     <------- BasicBlock #3
;   A[1] += B1;
; }


define i32 @foo(double* nocapture %A, float* nocapture %B, i32 %g) {
; CHECK-LABEL: @foo(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[TMP0:%.*]] = bitcast float* [[B:%.*]] to <2 x float>*
; CHECK-NEXT:    [[TMP1:%.*]] = load <2 x float>, <2 x float>* [[TMP0]], align 4
; CHECK-NEXT:    [[TOBOOL:%.*]] = icmp eq i32 [[G:%.*]], 0
; CHECK-NEXT:    [[TMP2:%.*]] = fadd <2 x float> [[TMP1]], <float 5.000000e+00, float 8.000000e+00>
; CHECK-NEXT:    br i1 [[TOBOOL]], label [[IF_END:%.*]], label [[IF_THEN:%.*]]
; CHECK:       if.then:
; CHECK-NEXT:    [[CALL:%.*]] = tail call i32 (...) @bar()
; CHECK-NEXT:    br label [[IF_END]]
; CHECK:       if.end:
; CHECK-NEXT:    [[TMP3:%.*]] = fpext <2 x float> [[TMP2]] to <2 x double>
; CHECK-NEXT:    [[TMP4:%.*]] = bitcast double* [[A:%.*]] to <2 x double>*
; CHECK-NEXT:    [[TMP5:%.*]] = load <2 x double>, <2 x double>* [[TMP4]], align 8
; CHECK-NEXT:    [[TMP6:%.*]] = fadd <2 x double> [[TMP3]], [[TMP5]]
; CHECK-NEXT:    [[TMP7:%.*]] = bitcast double* [[A]] to <2 x double>*
; CHECK-NEXT:    store <2 x double> [[TMP6]], <2 x double>* [[TMP7]], align 8
; CHECK-NEXT:    ret i32 undef
;
entry:
  %0 = load float, float* %B, align 4
  %arrayidx1 = getelementptr inbounds float, float* %B, i64 1
  %1 = load float, float* %arrayidx1, align 4
  %add = fadd float %0, 5.000000e+00
  %add2 = fadd float %1, 8.000000e+00
  %tobool = icmp eq i32 %g, 0
  br i1 %tobool, label %if.end, label %if.then

if.then:
  %call = tail call i32 (...) @bar()
  br label %if.end

if.end:
  %conv = fpext float %add to double
  %2 = load double, double* %A, align 8
  %add4 = fadd double %conv, %2
  store double %add4, double* %A, align 8
  %conv5 = fpext float %add2 to double
  %arrayidx6 = getelementptr inbounds double, double* %A, i64 1
  %3 = load double, double* %arrayidx6, align 8
  %add7 = fadd double %conv5, %3
  store double %add7, double* %arrayidx6, align 8
  ret i32 undef
}

declare i32 @bar(...)
