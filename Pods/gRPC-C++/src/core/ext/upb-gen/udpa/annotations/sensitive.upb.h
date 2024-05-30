/* This file was generated by upb_generator from the input file:
 *
 *     udpa/annotations/sensitive.proto
 *
 * Do not edit -- your changes will be discarded when the file is
 * regenerated. */

#ifndef UDPA_ANNOTATIONS_SENSITIVE_PROTO_UPB_H_
#define UDPA_ANNOTATIONS_SENSITIVE_PROTO_UPB_H_

#include "upb/generated_code_support.h"

#include "udpa/annotations/sensitive.upb_minitable.h"

#include "google/protobuf/descriptor.upb_minitable.h"

// Must be last.
#include "upb/port/def.inc"

#ifdef __cplusplus
extern "C" {
#endif

struct google_protobuf_FieldOptions;


UPB_INLINE bool udpa_annotations_has_sensitive(const struct google_protobuf_FieldOptions* msg) {
  return _upb_Message_HasExtensionField(msg, &udpa_annotations_sensitive_ext);
}
UPB_INLINE void udpa_annotations_clear_sensitive(struct google_protobuf_FieldOptions* msg) {
  _upb_Message_ClearExtensionField(msg, &udpa_annotations_sensitive_ext);
}
UPB_INLINE bool udpa_annotations_sensitive(const struct google_protobuf_FieldOptions* msg) {
  const upb_MiniTableExtension* ext = &udpa_annotations_sensitive_ext;
  UPB_ASSUME(!upb_IsRepeatedOrMap(&ext->field));
  UPB_ASSUME(_upb_MiniTableField_GetRep(&ext->field) == kUpb_FieldRep_1Byte);
  bool default_val = false;
  bool ret;
  _upb_Message_GetExtensionField(msg, ext, &default_val, &ret);
  return ret;
}
UPB_INLINE void udpa_annotations_set_sensitive(struct google_protobuf_FieldOptions* msg, bool val, upb_Arena* arena) {
  const upb_MiniTableExtension* ext = &udpa_annotations_sensitive_ext;
  UPB_ASSUME(!upb_IsRepeatedOrMap(&ext->field));
  UPB_ASSUME(_upb_MiniTableField_GetRep(&ext->field) == kUpb_FieldRep_1Byte);
  bool ok = _upb_Message_SetExtensionField(msg, ext, &val, arena);
  UPB_ASSERT(ok);
}
#ifdef __cplusplus
}  /* extern "C" */
#endif

#include "upb/port/undef.inc"

#endif  /* UDPA_ANNOTATIONS_SENSITIVE_PROTO_UPB_H_ */
