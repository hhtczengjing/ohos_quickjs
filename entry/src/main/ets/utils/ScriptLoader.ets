import { common } from '@kit.AbilityKit';
import { util } from '@kit.ArkTS';

/**
 * Load JS script from rawfile and return its content as string.
 * The file path is relative to entry/src/main/resources/rawfile/
 * e.g. 'scripts/basic_script.js'
 */
export function loadScriptFromRawFile(context: common.UIAbilityContext, fileName: string): string {
  const resourceManager = context.resourceManager;
  try {
    const buffer = resourceManager.getRawFileContentSync(fileName);
    const decoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
    return decoder.decode(buffer);
  } catch (e) {
    console.error(`Failed to load rawfile: ${fileName}, error: ${JSON.stringify(e)}`);
    return '';
  }
}
