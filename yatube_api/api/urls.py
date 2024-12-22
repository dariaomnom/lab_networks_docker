from django.urls import include, path
from rest_framework.routers import SimpleRouter

from .views import CommentViewSet, FollowViewSet, GroupViewSet, PostViewSet

default_router = SimpleRouter()
default_router.register('posts', PostViewSet)
default_router.register('groups', GroupViewSet)
default_router.register('follow', FollowViewSet, basename='follows')

comment_router = SimpleRouter()
comment_router.register('comments', CommentViewSet, basename='comments')

urlpatterns = [
    path('posts/<int:post_id>/', include(comment_router.urls)),
    path('', include(default_router.urls)),
    path('', include('djoser.urls')),
    path('', include('djoser.urls.jwt')),
]
