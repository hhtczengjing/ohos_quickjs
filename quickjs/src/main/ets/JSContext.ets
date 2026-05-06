/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { JSValue } from './JSValue';
import qjs from 'libquickjs.so';

export class JSContext {
  private _engineHandle: bigint = 0n;
  private nameValue: string = '';

  get engineHandle(): bigint {
    return this._engineHandle;
  }

  constructor() {
    this._engineHandle = qjs.createEngine();
  }

  get globalObject(): JSValue {
    const handle = qjs.getGlobal(this._engineHandle);
    return new JSValue(this, handle);
  }

  get exception(): JSValue | null {
    return null;
  }

  set exception(value: JSValue | null) {
  }

  exceptionHandler?: (context: JSContext, exception: JSValue) => void;

  evaluateScript(script: string, sourceURL?: string): JSValue {
    const url = sourceURL ?? 'evaluate';
    const handle = qjs.evaluateScript(this.engineHandle, script, url);
    return new JSValue(this, handle);
  }

  setObject(object: Record<string, number | string | boolean> | JSValue, name: string): void {
    if (object instanceof JSValue) {
      qjs.setProperty(this.engineHandle, this.globalObject.valueHandle, name, object.valueHandle);
    } else {
      const objHandle = qjs.createObject(this.engineHandle);
      for (const key of Object.keys(object)) {
        const val = object[key];
        if (typeof val === 'number') {
          const numHandle = qjs.createNumber(this.engineHandle, val);
          qjs.setProperty(this.engineHandle, objHandle, key, numHandle);
        } else if (typeof val === 'string') {
          const strHandle = qjs.createString(this.engineHandle, val);
          qjs.setProperty(this.engineHandle, objHandle, key, strHandle);
        } else if (typeof val === 'boolean') {
          const boolHandle = qjs.createBoolean(this.engineHandle, val);
          qjs.setProperty(this.engineHandle, objHandle, key, boolHandle);
        }
      }
      qjs.setProperty(this.engineHandle, this.globalObject.valueHandle, name, objHandle);
    }
  }

  getGlobalProperty(name: string): JSValue {
    return this.globalObject.getProperty(name);
  }

  get name(): string {
    return this.nameValue;
  }

  set name(value: string) {
    this.nameValue = value;
  }

  release(): void {
    if (this.engineHandle !== 0n) {
      qjs.releaseEngine(this.engineHandle);
      this._engineHandle = 0n;
    }
  }
}
