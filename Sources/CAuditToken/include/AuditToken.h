//===----------------------------------------------------------------------===//
// Copyright © 2025-2026 Apple Inc. and the container project authors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   https://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//===----------------------------------------------------------------------===//

// App Store patch:
// Upstream declared private SPI `xpc_dictionary_get_audit_token` here. That
// symbol caused App Review rejection (Guideline 2.5.1). The CAuditToken target
// is no longer linked; peer EUID checks live in ContainerXPC/XPCServer.swift
// using public APIs only. This header is retained so upstream refreshes stay
// easy to diff — do not reintroduce the SPI declaration.
