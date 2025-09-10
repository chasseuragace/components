read the acknowledgement
# difference in planned vs the current plan
    - previously planned 
        - we collect the data modeuls into i structured unit 
        - ie the project architecture
    - whats needs be done as of  today  
        - read todos.md
    - what is current focus on 
        - the data 
        - the folder arctitecture 
        - the clean arcitecture gen 
            - the module gen
            - project setup gen 
        - use are setting up 
            /Users/ajaydahal/code/variant_dashboard/lib/app/udaan_saarathi
            as of now as usinf 
            - /Users/ajaydahal/code/variant_dashboard/lib/app/app.dart
                - createprovider for app mode 
                - confivure it through config file in lib/config.dart
                    - create readme for the config file
        - what will happen next 
            - merge's rojans work
            - run app in the 
                - todo vs the preview (hot reload based, read in runtime )
                    - todos.json
                    - mark-todos  mcp 
                        - mark todo done 
                        - comment on todo 
                            - take gir logged in user 
                        - initialize todo mcp
                            - the persona
                                - the knowledge 
                                    - everything said by htis readme and
                                    - /Users/ajaydahal/code/variant_dashboard/resources
                            - 
                 -rojan will  use inspector widget 
                    - data will be 
                        - generated  
                        - architecture followed 
                    - todos mentioned clearly 
            - todos will be updated by me with rojan's progress
                - scope  : current 
                    -  next week 
                    -  project knowledge scope : in cloud with rag 
                -

- what needs crystalized 
    - app startss
    - splash 
    - onboarding 
    - navigation scaffold 
        - dashboard
        - jobs listing 
        - job details 
        - profile 
    - features 
    - TODO : planning  in progress 
        - personalize | preferences 
            - job titles 
            - job preference 
        - searchParams
            - by preference
            - other filter  
        - filters ui 
- how things crystakized 
    - ui 
        - the udaan saarathi 
    - system 
        - the test cases 
            - AppInstanceConfig
                - laods from file 
                    - tellls which app instance to load 
            - abstract and extend this to 
                - read todos jsons
                    - convert todos md to json ?
                
                - docs as md 
                    - we need markdown rendering , specific in pm mode 
            - set  : build script to load different pubspec for different development mode build
                - document how to setup for udaansaarathi pure app
                - document how to setup for udaansaarathi  PM
                - document for the variant dashboard
                    {   source : build_config.json
                        data : {
                            appInstance : pm , us, vd (project management , udaan sarathi, variant dashboard )
                            config : {
                                filese : {
                                    pubspec : instance_pubspec.yaml(pm_pubspec.yaml, replace rename  existing pubspec's content with this , dependencies  )
                                    todos : "instance_pubspec/todos.md"
                                        
                                        - update :  todos from ide mcp 
                                            - eg: pm/pm_todos.josn 
                                                - usecase : make that pm task as done 
                                                    - add this as comment on the  task
                                        - refresh 
                                            - move the todo.json's content to 
                                                - config.dart
                                                    - this way app can always read from the dart, not filestorage.
                                                - NOte this is not the source fo truth 
                                   docs: 
                                    -      
                                }
                                

                            }
                        }
                        
                    }

            


    
            
- what to do next : 
    - provider is showing error 
        - class that does what i said is not implemented . 
    - can hte ide do it ? 
        - mcp not yet
        - config files 
            - yes 
        - providers 
            yes 
        - 
- what i did 
    - created /Users/ajaydahal/code/variant_dashboard/lib/app/udaan_saarathi/pm_board.dart
    - hooked up 
        provider required at 
        /Users/ajaydahal/code/variant_dashboard/lib/app/provider.dart
        to be used here 
        /Users/ajaydahal/code/variant_dashboard/lib/app/provider.dart

- create tabs in the 
    -/Users/ajaydahal/code/variant_dashboard/lib/app/provider.dart
    - render fake content 
        - create module 
            - data-domain-providers 
                - for docs and todos as json 
    - api call for todos
        - toggel status  
        - add comment (todoId , commenttext, parentId)

- Rojans Scope of work 
    - restructure things inside the udaan_saarathi
        - 
- what i need to do 
    - have asignee 
    - identfy current git user 
    - have assigned to  in hte todos 
        - for todos by user id to work 
    - separate source to truth files 
    - have server to manipulate files 
    - setup mcp for ides 
-  enable rojan such :  he can switch between pm and us , by toing a triple tap 

- rojan 's access is read only here , in my architecture ':
    - mark complete 
    - add comment / reply 
    - read docs 
    - he edit hte source of truth if required 
    - restriction is just on hte ui to make things simpler.
    - rojan canadd as he progresses 
