component {
  this.name = 'SampleSignhostApplication';
  this.root = getDirectoryFromPath(getCurrentTemplatePath());

  this.mappings[ '/framework' ] = 'D:/Dropbox/Projects/thirdparty/fw1/framework';
  this.mappings[ '/signhost-api' ] = this.root;
  this.mappings[ '/model' ] = this.root & '/model';
  this.mappings[ '/cava' ] = 'D:/Dropbox/Projects/cava';
  this.mappings[ '/mustang' ] = 'D:/Dropbox/Projects/mustang-shared';
  this.mappings[ '/javaloader' ] = 'D:/Dropbox/Projects/thirdparty/javaloader';

  function onApplicationStart() {
    application.beanFactory = new framework.ioc(
      [
        '/mustang/services',
        '/cava/services',
        '/cava/beans',
        '/cava/subsystems/api/services',
        '/cava/lib/cfml',
        '/cava/webroot/tests/mockdata/beans'
      ],
      {
        'transients' = [
          'api',
          'dynamic',
          'perfectview',
          'scenarios',
          'vendors',
          'verifications'
        ],
        'constants' = {
          'root' = this.root,
          'config' = {
            'paths' = {
              'jsonLib' = 'D:\Dropbox\Projects\cava\lib\java\gson-2.8.jar'
            }
          }
        }
      }
    );
  }
}