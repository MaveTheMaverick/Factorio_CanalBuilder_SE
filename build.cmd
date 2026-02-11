del CanalBuilderMAV_*.zip
xcopy ".\graphics\" ".\CanalBuilderMAV_3.0.0\graphics\" /s /r /y /q
xcopy ".\locale\" ".\CanalBuilderMAV_3.0.0\locale\" /s /r /y /q
xcopy ".\prototypes\" ".\CanalBuilderMAV_3.0.0\prototypes\" /s /r /y /q
xcopy ".\changelog.txt" ".\CanalBuilderMAV_3.0.0\" /r /y /q
xcopy ".\info.json" ".\CanalBuilderMAV_3.0.0\" /r /y /q
xcopy ".\LICENSE" ".\CanalBuilderMAV_3.0.0\" /r /y /q
xcopy ".\thumbnail.png" ".\CanalBuilderMAV_3.0.0\" /r /y /q
xcopy ".\*.lua" ".\CanalBuilderMAV_3.0.0\" /r /y /q
7z a -tzip CanalBuilderMAV_3.0.0.zip ./CanalBuilderMAV_3.0.0