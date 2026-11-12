"""Verify the installed toolbox root and MATLAB path configuration."""
# Created with GPT6A for the MATLAB Project and toolbox release workflow.
import argparse
from pathlib import PurePosixPath
from urllib.parse import unquote
import xml.etree.ElementTree as ET
from zipfile import ZipFile


def verify(filename):
    with ZipFile(filename) as archive:
        files = {unquote(name[len('fsroot/'):]) for name in archive.namelist()
                 if name.startswith('fsroot/') and not name.endswith('/')}
        required = {
            '+arduinoioaddons/+M5Stack/M5Unified.m',
            '+arduinoioaddons/+M5Stack/src/M5UnifiedML.h',
            '+arduinoioaddons/+M5Stack/html/M5Unified.html',
            'GettingStarted.m', 'README.md', 'CHANGELOG.md', 'VERSION',
            'images/M5Unified4Matlab.png',
            'Utilities/prepareForM5Stack.m', 'Examples/ExampleM5Chessboard.m',
        }
        assert required <= files, f'Missing files at install root: {required - files}'
        assert not any(name.startswith('M5Unified Add-On Library for Arduino/') for name in files), \
            'The library folder must not be nested inside the install root.'
        assert not any(name.startswith('resources/project/') or
                       PurePosixPath(name).suffix in {'.prj', '.asv'} for name in files), \
            'Development artifacts must not be packaged.'
        assert archive.read('metadata/primaryScreenShot.png') == archive.read('fsroot/images/M5Unified4Matlab.png'), \
            'The toolbox image must be the original M5Unified logo collage.'
        config = ET.fromstring(archive.read('metadata/configuration.xml'))
        ns = {'c': config.tag.split('}')[0].lstrip('{')}
        paths = {node.text.strip('/') if node.text else ''
                 for node in config.findall('c:matlabPaths/c:matlabPath', ns)}
        assert paths == {'', 'Utilities', 'Examples'}, f'Incorrect MATLAB paths: {paths}'
        guide = config.find('c:gettingStartedDocPath', ns)
        assert guide is not None and guide.text.lstrip('/') == 'GettingStarted.m', \
            'Getting Started must be at the install root.'
    print(f'PASS: {filename}: {len(files)} release files at the correct install root.')


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('installers', nargs='+')
    for installer in parser.parse_args().installers:
        verify(installer)
